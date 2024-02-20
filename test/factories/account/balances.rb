FactoryBot.define do
  factory :account_balance, class: "Account::Balance" do
    account
    balance { "10.50" }
    sequence :date do |n|
      n.days.ago
    end
  end
end
