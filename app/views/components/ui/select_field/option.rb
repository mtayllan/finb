class UI::SelectField::Option < ViewComponent::Base
  erb_template <<-ERB
    <button
      type="button"
      class="flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none hover:bg-accent focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
      data-action="ui--select-field#selectOption"
      data-value="<%= @value %>"
    >
      <%= content || @label %>
    </button>
  ERB

  def initialize(value:, label: nil)
    @value, @label = value, label
  end
end
