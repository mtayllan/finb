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
      class: "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-xs transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
    )
  end
end
