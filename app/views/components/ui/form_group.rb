class UI::FormGroup < ViewComponent::Base
  def initialize(data: {})
    @data = data
  end

  def call
    content_tag :div, class: "grid w-full items-center gap-1.5 my-5", data: @data do
      content
    end
  end
end
