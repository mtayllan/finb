class UI::Button < ViewComponent::Base
  def initialize(href: nil, data: {}, form: nil)
    @href = href
    @data = data
    @form = form
  end

  def classes
    "inline-flex items-center justify-center whitespace-nowrap rounded-md
     text-sm font-medium transition-colors focus-visible:outline-hidden
     focus-visible:ring-1 focus-visible:ring-ring bg-primary text-primary-foreground
     shadow hover:bg-primary/90 px-4 py-2"
  end
end
