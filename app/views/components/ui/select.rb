class UI::Select < ViewComponent::Base
  renders_many :options, "UI::SelectOption"

  def initialize(name:, value:, placeholder: nil)
    @name, @value, @placeholder = name, value, placeholder
  end
end
