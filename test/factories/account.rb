FactoryBot.define do
  factory :account do
    name { Faker::Bank.name }
    color { "blue" }
    initial_balance { 0 }
    initial_balance_date { Date.current }
    user
  end
end
