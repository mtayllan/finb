# frozen_string_literal: true

class FormLabelComponent < ApplicationComponent
  def initialize(form:, attribute:)
    @form = form
    @attribute = attribute
  end

  def view_template
    plain @form.label @attribute, class: "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
  end
end
