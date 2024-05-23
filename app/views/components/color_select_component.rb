

class ColorSelectComponent < ApplicationComponent
  def initialize(form:, attribute:, default_value:)
    @form = form
    @attribute = attribute
    @default_value = default_value
  end

  def view_template
    div(data_controller: "components--color-select") do
      plain @form.hidden_field(@attribute, value: @default_value)

      div(class: "grid grid-cols-6 gap-1 w-fit") do
        COLORS.each do |color|
          button(
            type: "button",
            style: "background: #{color}",
            data: {
              action: "components--color-select#select",
              active: "#{color == @default_value}",
              "components--color-select-color-param" => color
            },
            class: "h-10 w-10 cursor-pointer rounded-md hover:scale-105 data-[active=true]:border-foreground data-[active=true]:border-2"
          )
        end
      end
    end
  end

  COLORS = %w[
    #27272a
    #64748b
    #78716c
    #c2410c
    #f97316
    #f59e0b
    #eab308
    #84cc16
    #14532d
    #10b981
    #14b8a6
    #22d3ee
    #0ea5e9
    #3b82f6
    #1e3a8a
    #6366f1
    #8b5cf6
    #a855f7
    #d946ef
    #ec4899
    #f43f5e
    #dc2626
    #881337
    #fca5a5
  ]

  private_constant :COLORS
end
