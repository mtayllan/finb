class ColorSelectComponent < ViewComponent::Base
  COLORS = ["#27272a", "#64748b", "#78716c", "#c2410c", "#f97316", "#f59e0b",
  "#eab308", "#84cc16", "#14532d", "#10b981", "#14b8a6", "#22d3ee",
  "#0ea5e9", "#3b82f6", "#1e3a8a", "#6366f1", "#8b5cf6", "#a855f7",
  "#d946ef", "#ec4899", "#f43f5e", "#dc2626", "#881337", "#fca5a5"]

  def initialize(form, attribute, default_value: nil)
    @form, @attribute, @default_value = form, attribute, default_value
  end
end
