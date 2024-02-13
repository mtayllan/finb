FactoryBot.define do
  factory :transaction do
    description { Faker::Lorem.sentence }
    date { Date.current }
    value { 10 }
    category
    account
  end
end
