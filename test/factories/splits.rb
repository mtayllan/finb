FactoryBot.define do
  factory :split do
    association :source_transaction, factory: :transaction
    association :payer, factory: :user
    association :owes_to, factory: :user
    amount_owed { 25.00 }
    paid_at { nil }

    trait :paid do
      paid_at { 1.day.ago }
    end

    trait :with_category do
      association :owes_to_category, factory: :category
    end
  end
end
