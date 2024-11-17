class UI::SelectField < ViewComponent::Base
  renders_many :options, "UI::SelectField::Option"

  def initialize(name:, value:, placeholder: nil)
    @name, @value, @placeholder = name, value, placeholder
  end
end
