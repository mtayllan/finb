class UpdateIconNames < ActiveRecord::Migration[8.0]
  def change
    Category.where(icon: "game").update_all(icon: "game-controller")
    Category.where(icon: "pc").update_all(icon: "desktop")
    Category.where(icon: "food").update_all(icon: "bowl-food")
    Category.where(icon: "shopping_cart").update_all(icon: "shopping-cart")
    Category.where(icon: "fork_knife").update_all(icon: "fork-knife")
    Category.where(icon: "t_shirt").update_all(icon: "t-shirt")
    Category.where(icon: "road").update_all(icon: "road-horizon")
    Category.where(icon: "youtube").update_all(icon: "youtube-logo")
    Category.where(icon: "chart_line_up").update_all(icon: "chart-line-up")
    Category.where(icon: "hand_coins").update_all(icon: "hand-coins")
    Category.where(icon: "airplane_takeoff").update_all(icon: "airplane-takeoff")
    Category.where(icon: "bowl_food").update_all(icon: "bowl-food")
    Category.where(icon: "person_arms_spread").update_all(icon: "person-arms-spread")
    Category.where(icon: "piggy_bank").update_all(icon: "piggy-bank")
    Category.where(icon: "credit_card").update_all(icon: "credit_card")
  end
end
