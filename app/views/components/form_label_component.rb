class FormLabelComponent < ViewComponent::Base
  def initialize(form, attribute)
    @form, @attribute = form, attribute
  end

  def call
    @form.label(
      @attribute,
      class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
    )
  end
end
