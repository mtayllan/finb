class UI::TextField < ViewComponent::Base
  def initialize(form, attribute)
    @form, @attribute = form, attribute
  end

  def call
    @form.text_field(
      @attribute,
      class: "w-full input"
    )
  end
end
