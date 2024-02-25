require "test_helper"

class TransferTest < ActiveSupport::TestCase
  test "invalid with equal origin and target accounts" do
    account = create(:account)
    transfer = Transfer.new(value: 50, date: Date.today, origin_account: account, target_account: account)
    assert_not transfer.valid?
    assert_includes transfer.errors[:target_account], "must be different from Origin Account"
  end

  test "valid with different origin and target accounts" do
    origin_account = create(:account)
    target_account = create(:account)
    transfer = Transfer.new(value: 50, date: Date.today, origin_account:, target_account:)
    assert transfer.valid?
  end
end
