require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  test 'invalid with equal origin and target accounts' do
    account = Account.create(name: 'Test')
    transfer = Transfer.new(value: 50, date: Date.today, origin_account: account, target_account: account)
    refute transfer.valid?
    assert_includes transfer.errors[:target_account], "must be different from Origin Account"
  end

  test 'valid with different origin and target accounts' do
    origin_account = Account.create(name: 'Origin Account')
    target_account = Account.create(name: 'Target Account')
    transfer = Transfer.new(value: 50, date: Date.today, origin_account:, target_account:)
    assert transfer.valid?
  end
end
