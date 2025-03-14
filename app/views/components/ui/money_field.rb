class UI::MoneyField < ViewComponent::Base
  def initialize(form, attribute, default_value: nil)
    @form, @attribute = form, attribute
    @default_value = default_value || form.object[attribute]
  end

  def call
    @form.text_field(
      @attribute,
      value: @default_value,
      data: { controller: "ui--money-field", action: "ui--money-field#format" },
      class: "input w-full",
    )
  end
end
