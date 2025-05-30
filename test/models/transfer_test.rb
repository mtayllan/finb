require "test_helper"

class TransferTest < ActiveSupport::TestCase
  test "invalid with equal origin and target accounts" do
    account = accounts(:bank_one)
    transfer = Transfer.new(value: 50, date: Time.zone.today, origin_account: account, target_account: account)
    assert_not transfer.valid?
    assert_includes transfer.errors[:target_account], "must be different from Origin Account"
  end

  test "valid with different origin and target accounts" do
    origin_account = accounts(:bank_one)
    target_account = accounts(:savings_one)
    transfer = Transfer.new(value: 50, date: Time.zone.today, origin_account:, target_account:)
    assert transfer.valid?
  end
end
