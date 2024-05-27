class SelectComponent < ViewComponent::Base
  renders_many :options, "SelectOptionComponent"

  def initialize(name:, value:, placeholder: nil)
    @name, @value, @placeholder = name, value, placeholder
  end
end
