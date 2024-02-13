FactoryBot.define do
  factory :transfer do
    association :target_account, factory: :account
    association :origin_account, factory: :account
    description { Faker::Lorem.sentence }
    value { 10 }
    date { Date.current }
  end
end
