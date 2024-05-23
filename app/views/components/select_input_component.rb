class SelectInputComponent < ApplicationComponent
  include Phlex::DeferredRender

  def initialize(form:, attribute:, placeholder:, options:, value:)
    @form = form
    @attribute = attribute
    @placeholder = placeholder
    @value = value
    @options = []
  end

  def view_template
    div(data_controller: "components--select", class: "relative") do
      input(
        placeholder: @placeholder,
        data: {
           action: "focus->components--select#openDropdown components--select#search",
          "components__select_target" => "searchInput"
        },
        value: @options.find { _1[:value] == @value }&.[](:label),
        class: "flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50",
      )

      plain @form.hidden_field(@attribute, data: { "components__select_target" => "inputValue" }, value: @value)

      div(
        data_components__select_target: "dropdown",
        class: "hidden absolute right-0 mt-1 w-full z-10 overflow-auto max-h-64 rounded-md border bg-popover text-popover-foreground shadow-md"
      ) do
        @options.each do |option|
          button(
            type: "button",
            class: "flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none hover:bg-accent focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
            data: {
              action: "components--select#selectOption",
              components__select_option_param: option[:value]
            }
          ) do
            plain yield(option[:item]).presence || option[:label]
          end
          whitespace
        end
      end
    end
  end

  def with_option(value:, label:, item:, &block)
    if block_given?
      @options << yield(item)
    else
      @options << { value: value, label: label, item: item }
    end
  end
end
