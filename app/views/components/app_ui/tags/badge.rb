class AppUI::Tags::Badge < ViewComponent::Base
  def initialize(tag, size: :md)
    @tag = tag
    @size = size
  end

  private

  def size_classes
    case @size
    when :sm then "text-xs px-2 py-0.5"
    when :md then "text-sm px-2.5 py-1"
    when :lg then "text-base px-3 py-1.5"
    else "text-sm px-2.5 py-1"
    end
  end

  def background_color
    # Use tag color with transparency
    "#{@tag.color}20"
  end

  def text_color
    @tag.color
  end
end
