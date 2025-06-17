class UI::NumberField < ViewComponent::Base
  def initialize(form, attribute)
    @form, @attribute = form, attribute
  end

  def call
    @form.number_field(
      @attribute,
      class: "w-full input"
    )
  end
end
