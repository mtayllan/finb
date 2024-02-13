FactoryBot.define do
  factory :account do
    name { Faker::Bank.name }
    color { "blue" }
    initial_balance { 0 }
  end
end
