class UI::Button < ViewComponent::Base
  def initialize(href: nil, data: {}, form: nil)
    @href = href
    @data = data
    @form = form
  end

  def classes
    "btn btn-primary"
  end
end
