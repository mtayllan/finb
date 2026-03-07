require "test_helper"

class CreditCards::StatementPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
    @credit_card = accounts(:credit_one)
    @statement = credit_card_statements(:cc_stmt_current)
  end

  test "should get new" do
    get new_credit_card_statement_payment_url(@credit_card, month: @statement.month)
    assert_response :success
  end

  test "should create statement payment and corresponding" do
    origin_account = accounts(:bank_one)
    payment_date = Date.current

    assert_difference("Transfer.count") do
      post credit_card_statement_payment_url(@credit_card), params: {
        month: @statement.month,
        statement_id: @statement.id,
        origin_account_id: origin_account.id,
        date: payment_date.to_fs(:day_month_year)
      }
    end

    assert_redirected_to credit_card_url(@credit_card, month: @statement.month)
    assert_equal flash[:notice], "Statement paid successfully."
    assert_equal payment_date, @statement.reload.paid_at.to_date
  end

  test "should use submitted date for the transfer" do
    origin_account = accounts(:bank_one)
    payment_date = 1.week.from_now.to_date

    assert_difference("Transfer.count") do
      post credit_card_statement_payment_url(@credit_card), params: {
        month: @statement.month,
        statement_id: @statement.id,
        origin_account_id: origin_account.id,
        date: payment_date.to_fs(:day_month_year)
      }
    end

    transfer = Transfer.find_by!(origin_account: origin_account, target_account: @credit_card)
    assert_equal payment_date, transfer.date
    assert_equal payment_date, @statement.reload.paid_at.to_date
  end
end
