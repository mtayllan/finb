require "test_helper"

class StatementAnalysisTest < ActiveSupport::TestCase
  test "validates presence of total_rows" do
    analysis = StatementAnalysis.new(account: accounts(:bank_one))
    assert_not analysis.valid?
    assert_includes analysis.errors[:total_rows], "can't be blank"
  end

  test "cannot import completed analysis" do
    analysis = StatementAnalysis.create!(
      account: accounts(:bank_one),
      total_rows: 1,
      status: :completed
    )

    assert_raises(RuntimeError, "Cannot import a completed analysis") do
      analysis.import_transactions!
    end
  end

  test "raises error when importing items without categories" do
    analysis = StatementAnalysis.create!(
      account: accounts(:bank_one),
      total_rows: 1
    )

    analysis.items.create!(
      description: "Test",
      date: Date.current,
      value: 100,
      row_number: 1,
      should_import: true
      # category_id is nil
    )

    assert_raises(RuntimeError, "All selected items must have a category assigned") do
      analysis.import_transactions!
    end
  end

  test "can_edit? returns true for pending status" do
    analysis = StatementAnalysis.new(status: :pending)
    assert analysis.can_edit?
  end

  test "can_edit? returns false for completed status" do
    analysis = StatementAnalysis.new(status: :completed)
    assert_not analysis.can_edit?
  end
end
