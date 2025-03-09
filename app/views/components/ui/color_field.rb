class UI::ColorField < ViewComponent::Base
  COLORS = [
    # Blacks/Grays
    "#27272a", "#1e293b", "#334155", "#475569", "#64748b", "#78716c",
    # Reds
    "#7f1d1d", "#881337", "#9d174d", "#b91c1c", "#dc2626", "#e11d48", "#f43f5e",
    # Oranges
    "#c2410c", "#be123c", "#f97316", "#fb923c", "#fdba74",
    # Yellows
    "#f59e0b", "#eab308", "#fbbf24", "#fde047",
    # Greens
    "#bef264", "#84cc16", "#4ade80", "#14532d", "#10b981", "#34d399",
    # Teals/Turquoise
    "#14b8a6", "#2dd4bf", "#22d3ee", "#06b6d4",
    # Blues
    "#0ea5e9", "#0284c7", "#3b82f6", "#1e3a8a",
    # Indigos/Purples
    "#4f46e5", "#6366f1", "#7c3aed", "#8b5cf6", "#9333ea", "#a855f7",
    # Magentas/Pinks
    "#c026d3", "#d946ef", "#db2777", "#ec4899", "#fb7185", "#fca5a5"
  ]

  def initialize(form, attribute, default_value: nil)
    @form, @attribute, @default_value = form, attribute, default_value
  end
end
