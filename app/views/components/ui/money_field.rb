class UI::MoneyField < ViewComponent::Base
  def initialize(form, attribute, default_value: nil, data: {})
    @form, @attribute = form, attribute
    @default_value = default_value || form.object[attribute]
    @data = data
  end

  def call
    data_attributes = {controller: "ui--money-field", action: "ui--money-field#format"}.merge(@data)

    @form.text_field(
      @attribute,
      value: @default_value,
      data: data_attributes,
      class: "input w-full"
    )
  end
end
