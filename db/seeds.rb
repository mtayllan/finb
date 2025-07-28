if Rails.env.development?
  # Create users for testing splits functionality
  user = User.create(username: "default", password: "qwe123")
  friend1 = User.create(username: "alice", password: "qwe123")
  friend2 = User.create(username: "bob", password: "qwe123")
  friend3 = User.create(username: "charlie", password: "qwe123")

  Category.create([
    {
      name: "Food",
      color: "#27272a",
      icon: "bowl-food",
      user:
    },
    {
      name: "Lunch",
      color: "#64748b",
      icon: "fork-knife",
      user:
    },
    {
      name: "Health",
      color: "#78716c",
      icon: "heartbeat",
      user:
    },
    {
      name: "Salary",
      color: "#10b981",
      icon: "money",
      user:
    },
    {
      name: "Games",
      color: "#14b8a6",
      icon: "game-controller",
      user:
    },
    {
      name: "House",
      color: "#a855f7",
      icon: "house",
      user:
    },
    {
      name: "Clothes",
      color: "#dc2626",
      icon: "t-shirt",
      user:
    },
    {
      name: "Cashback",
      color: "#3b82f6",
      icon: "money",
      user:
    },
    {
      name: "Gifts",
      color: "#84cc16",
      icon: "gift",
      user:
    },
    {
      name: "Tech",
      color: "#0ea5e9",
      icon: "desktop",
      user:
    },
    {
      name: "Collection",
      color: "#22d3ee",
      icon: "coins",
      user:
    },
    {
      name: "Taxes",
      color: "#0ea5e9",
      icon: "hand-coins",
      user:
    },
    {
      name: "Car",
      color: "#0ea5e9",
      icon: "car",
      user:
    },
    {
      name: "Trip",
      color: "#eab308",
      icon: "airplane-takeoff",
      user:
    }
  ])

  Account.create([
    {
      name: "Cash",
      color: "#27272a",
      initial_balance: 4000,
      initial_balance_date: 5.months.ago,
      kind: :checking,
      user:
    },
    {
      name: "Inter",
      color: "#ec4899",
      initial_balance: 6000,
      initial_balance_date: 5.months.ago,
      kind: :savings,
      user:
    },
    {
      name: "Bradesco",
      color: "#fca5a5",
      initial_balance: 10000,
      initial_balance_date: 5.months.ago,
      kind: :investment,
      user:
    },
    {
      name: "Itaú",
      color: "#22d3ee",
      initial_balance: 2500,
      initial_balance_date: 5.months.ago,
      kind: :credit_card,
      user:
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

  Account.all.find_each(&:update_balance)

  # Create some splits for testing
  # Get all users for split creation
  all_users = User.all
  transactions_with_splits = Transaction.where(value: ..0).limit(15)  # Get some expense transactions

  transactions_with_splits.each_with_index do |transaction, index|
    # Create splits where default user either owes money or is owed money
    if index.even?
      # Default user paid, others owe
      other_users = all_users.where.not(id: user.id).sample(rand(1..2))

      other_users.each do |other_user|
        Split.create(
          source_transaction: transaction,
          payer: user,
          owes_to: other_user,
          amount_owed: transaction.value.abs / (other_users.count + 1),
          owes_to_category: Category.all.sample,
          paid_at: [nil, rand(1..10).days.ago].sample  # Some paid, some pending
        )
      end
    else
      # Other user paid, default user owes
      payer = all_users.where.not(id: user.id).sample

      Split.create(
        source_transaction: transaction,
        payer: payer,
        owes_to: user,
        amount_owed: transaction.value.abs / 2,
        owes_to_category: Category.all.sample,
        paid_at: [nil, rand(1..10).days.ago].sample  # Some paid, some pending
      )
    end
  end

  puts "Created #{Split.count} splits for testing"
end
