#!/usr/bin/env bash
set -euo pipefail

# Fetches open Dependabot PRs, filters patch-only updates, and runs bundle update.
# Usage: .github/bump_patch_gems.sh [--dry-run]

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

is_patch() {
  local old="$1" new="$2"

  local old_major old_minor old_patch
  local new_major new_minor new_patch

  IFS='.' read -r old_major old_minor old_patch <<< "$old"
  IFS='.' read -r new_major new_minor new_patch <<< "$new"

  # Must have at least major.minor.patch
  [[ -z "${old_patch:-}" || -z "${new_patch:-}" ]] && return 1

  [[ "$old_major" == "$new_major" && "$old_minor" == "$new_minor" && "$old_patch" != "$new_patch" ]]
}

echo "Fetching open Dependabot PRs..."

prs=$(gh pr list \
  --author "app/dependabot" \
  --state open \
  --limit 200 \
  --json number,title)

patch_gems=()
skipped=()

while IFS= read -r title; do
  # Title format: "build(deps): bump <gem> from <old> to <new>"
  if [[ "$title" =~ bump[[:space:]]([^[:space:]]+)[[:space:]]from[[:space:]]([0-9][^[:space:]]*)[[:space:]]to[[:space:]]([0-9][^[:space:]]*) ]]; then
    gem="${BASH_REMATCH[1]}"
    old_ver="${BASH_REMATCH[2]}"
    new_ver="${BASH_REMATCH[3]}"

    if is_patch "$old_ver" "$new_ver"; then
      patch_gems+=("$gem")
      echo "  [patch] $gem $old_ver → $new_ver"
    else
      skipped+=("$gem ($old_ver → $new_ver)")
      echo "  [skip]  $gem $old_ver → $new_ver (minor/major)"
    fi
  fi
done < <(echo "$prs" | jq -r '.[].title')

echo ""

if [[ ${#patch_gems[@]} -eq 0 ]]; then
  echo "No patch updates found."
  exit 0
fi

cmd="bundle update --patch ${patch_gems[*]}"

echo "Patch gems to update: ${patch_gems[*]}"
echo ""
echo "Command:"
echo "  $cmd"
echo ""

if [[ "$DRY_RUN" == "true" ]]; then
  echo "[dry-run] Skipping execution."
  exit 0
fi

read -rp "Run bundle update now? [y/N] " confirm
if [[ "${confirm,,}" == "y" ]]; then
  eval "$cmd"
  git add Gemfile.lock
  git commit -m "build(deps): bump patch gems via dependabot (${patch_gems[*]})"
else
  echo "Aborted."
fi
