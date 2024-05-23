# frozen_string_literal: true

class H1Component < ApplicationComponent
  def view_template(&)
    h1(class: "scroll-m-20 text-4xl font-bold tracking-tight", &)
  end
end
