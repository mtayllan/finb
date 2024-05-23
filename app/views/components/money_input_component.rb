

class MoneyInputComponent < ApplicationComponent
  include Phlex::Rails::Helpers::TextField

  def initialize(attribute:, default_value:, form:)
    @attribute = attribute
    @default_value = default_value
    @form = form
  end

  def view_template
    plain @form.text_field(
      @attribute,
      value: @default_value,
      class: "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
      data: { controller: "components--money-input", action: "components--money-input#format" }
    )
  end
end
