class UI::Icon < ViewComponent::Base
  def initialize(icon, size: nil, color: "currentColor", variant: "regular", background: false)
    @icon, @size, @color, @variant, @background = icon, size, color, variant, background
  end

  erb_template <<-ERB
    <% if @background %>
      <div class="<%= background_size %> rounded-full grid place-items-center" style="background-color: <%= @color %>">
        <i class="<%= variant %> <%= icon %> <%= size %>"></i>
      </div>
    <% else %>
      <i class="<%= variant %> <%= icon %> <%= size %>" style="color: <%= @color %>"></i>
    <% end %>
  ERB

  private

  def size
    @size ? "text-#{@size}" : ""
  end

  def background_size
    case @size
    when "lg" then "w-6 h-6"
    when "xl" then "w-7 h-7"
    when "2xl" then "w-8 h-8"
    end
  end

  def icon
    "ph-#{@icon}"
  end

  # variants are: thin, light, regular, bold, fill, duotone
  def variant
    case @variant
    when "regular" then "ph"
    else "ph-#{@variant}"
    end
  end
end
