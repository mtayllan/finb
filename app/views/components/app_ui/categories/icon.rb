class AppUI::Categories::Icon < ViewComponent::Base
  def initialize(category, size: "2xl")
    @category = category
    @size = size
  end

  def call
    render UI::Icon.new(@category.icon, size: @size, background: true, color: @category.color)
  end

  AVAILABLE_ICONS = %w[
    student
    house
    game-controller
    desktop
    bowl-food
    shopping-cart
    fork-knife
    t-shirt
    car
    bus
    gift
    heartbeat
    money
    question
    road-horizon
    youtube-logo
    chart-line-up
    hand-coins
    coins
    airplane-takeoff
    person-arms-spread
    user
    bank
    piggy-bank
    credit-card
  ]
end
