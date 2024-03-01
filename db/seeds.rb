if Rails.env.development?
  Category.create([
    {
      name: "Food",
      color: "#0C356A",
      icon: "food"
    },
    {
      name: "Lunch",
      color: "#0174BE",
      icon: "fork_knife"
    },
    {
      name: "Health",
      color: "#7D0A0A",
      icon: "heartbeat"
    },
    {
      name: "Salary",
      color: "#3E6D9C",
      icon: "money"
    },
    {
      name: "Games",
      color: "#FFCD4B",
      icon: "game"
    },
    {
      name: "House",
      color: "#5463FF",
      icon: "house"
    },
    {
      name: "Clothes",
      color: "#36AE7C",
      icon: "t_shirt"
    },
    {
      name: "Cashback",
      color: "#6BCB77",
      icon: "money"
    },
    {
      name: "Gifts",
      color: "#FFD93D",
      icon: "gift"
    },
    {
      name: "Tech",
      color: "#161E54",
      icon: "pc"
    }
  ])

  Account.create([
    {
      name: "Cash",
      color: "#36AE7C",
      initial_balance: 4000,
      initial_balance_date: 5.months.ago
    },
    {
      name: "Inter",
      color: "#F87D0A",
      initial_balance: 6000,
      initial_balance_date: 5.months.ago
    },
    {
      name: "Bradesco",
      color: "#BA0401",
      initial_balance: 10000,
      initial_balance_date: 5.months.ago
    },
    {
      name: "Itaú",
      color: "#FF5901",
      initial_balance: 2500,
      initial_balance_date: 5.months.ago
    }
  ])

  initial_date = Date.current - 5.months
  end_date = Date.current

  200.times do |i|
    Transaction.create(
      description: Faker::Lorem.sentence(word_count: 3),
      value: Faker::Number.between(from: -300.0, to: 50.0),
      category: Category.all.sample,
      account: Account.all.sample,
      date: Faker::Date.between(from: initial_date, to: end_date)
    )
  end

  25.times do |i|
    origin = Account.all.sample
    target = Account.where.not(id: origin.id).sample
    Transfer.create(
      description: Faker::Lorem.sentence(word_count: 2),
      value: Faker::Number.between(from: 0, to: 300.0),
      origin_account: origin,
      target_account: target,
      date: Faker::Date.between(from: initial_date, to: end_date)
    )
  end

  Account.all.each(&:update_balance)
end
