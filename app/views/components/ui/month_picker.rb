class UI::MonthPicker < ViewComponent::Base
  def initialize(name:, initial_value:)
    @name = name
    @initial_value = initial_value
  end
end
