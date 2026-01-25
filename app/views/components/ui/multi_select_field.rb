class UI::MultiSelectField < ViewComponent::Base
  renders_many :options, ->(value:, label:, color: nil, selected: false) {
    @options_data ||= []
    @options_data << {value: value.to_s, label: label, color: color, selected: selected}
    Option.new(value: value, label: label, color: color, selected: selected)
  }

  def initialize(name:, selected_values: [], placeholder: nil)
    @name = name
    @selected_values = Array(selected_values).map(&:to_s)
    @placeholder = placeholder
    @options_data = []
  end

  attr_reader :options_data

  def selected_options_data
    @options_data.select { |o| @selected_values.include?(o[:value]) }
  end

  class Option < ViewComponent::Base
    def initialize(value:, label:, color: nil, selected: false)
      @value = value
      @label = label
      @color = color
      @selected = selected
    end

    def call
      content_tag :button,
        type: "button",
        class: "flex items-center gap-2 w-full px-3 py-2 text-left hover:bg-base-200 cursor-pointer",
        data: {
          action: "ui--multi-select-field#toggleOption",
          value: @value,
          label: @label,
          color: @color,
          selected: @selected
        } do
        safe_join([
          color_dot,
          content_tag(:span, @label, class: "flex-1"),
          check_icon
        ].compact)
      end
    end

    private

    def color_dot
      return nil unless @color
      content_tag(:span, nil, class: "w-3 h-3 rounded-full shrink-0", style: "background-color: #{@color}")
    end

    def check_icon
      content_tag(:i, nil, class: "ph ph-check #{"invisible" unless @selected}", data: {check: true})
    end
  end
end
