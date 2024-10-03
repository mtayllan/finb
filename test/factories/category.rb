FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }
    color { "blue" }
    icon { "house" }
    user
  end
end
