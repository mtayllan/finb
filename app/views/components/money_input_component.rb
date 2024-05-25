class MoneyInputComponent < ViewComponent::Base
  def initialize(form:, attribute:, default_value:)
    @form, @attribute, @default_value = form, attribute, default_value
  end

  def call
    @form.text_field(
      @attribute,
      value: @default_value,
      data: { controller: "components--money-input", action: "components--money-input#format" },
      class: "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
    )
  end
end
