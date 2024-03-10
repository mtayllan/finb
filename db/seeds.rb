if Rails.env.development?
  Category.create([
    {
      name: "Food",
      color: "#27272a",
      icon: "food"
    },
    {
      name: "Lunch",
      color: "#64748b",
      icon: "fork_knife"
    },
    {
      name: "Health",
      color: "#78716c",
      icon: "heartbeat"
    },
    {
      name: "Salary",
      color: "#10b981",
      icon: "money"
    },
    {
      name: "Games",
      color: "#14b8a6",
      icon: "game"
    },
    {
      name: "House",
      color: "#a855f7",
      icon: "house"
    },
    {
      name: "Clothes",
      color: "#dc2626",
      icon: "t_shirt"
    },
    {
      name: "Cashback",
      color: "#3b82f6",
      icon: "money"
    },
    {
      name: "Gifts",
      color: "#84cc16",
      icon: "gift"
    },
    {
      name: "Tech",
      color: "#0ea5e9",
      icon: "pc"
    }
  ])

  Account.create([
    {
      name: "Cash",
      color: "#27272a",
      initial_balance: 4000,
      initial_balance_date: 5.months.ago,
      kind: :checking
    },
    {
      name: "Inter",
      color: "#ec4899",
      initial_balance: 6000,
      initial_balance_date: 5.months.ago,
      kind: :savings
    },
    {
      name: "Bradesco",
      color: "#fca5a5",
      initial_balance: 10000,
      initial_balance_date: 5.months.ago,
      kind: :investment
    },
    {
      name: "Itaú",
      color: "#22d3ee",
      initial_balance: 2500,
      initial_balance_date: 5.months.ago,
      kind: :credit_card
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

  initial_date = Date.current.beginning_of_month
  20.times do |i|
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
