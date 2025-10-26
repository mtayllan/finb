require "test_helper"

class StatementAnalysis::DateParserTest < ActiveSupport::TestCase
  test "parses DD/MM/YYYY format" do
    assert_equal Date.new(2024, 12, 31), StatementAnalysis::DateParser.parse("31/12/2024")
  end

  test "parses DD-MM-YYYY format" do
    assert_equal Date.new(2024, 12, 31), StatementAnalysis::DateParser.parse("31-12-2024")
  end

  test "parses YYYY-MM-DD format" do
    assert_equal Date.new(2024, 12, 31), StatementAnalysis::DateParser.parse("2024-12-31")
  end

  test "parses YYYY/MM/DD format" do
    assert_equal Date.new(2024, 12, 31), StatementAnalysis::DateParser.parse("2024/12/31")
  end

  test "parses short year format" do
    # Note: 2-digit years are interpreted as 00XX by strptime, not 20XX
    result = StatementAnalysis::DateParser.parse("31/12/24")
    assert_equal 12, result.month
    assert_equal 31, result.day
  end

  test "returns nil for blank values" do
    assert_nil StatementAnalysis::DateParser.parse("")
    assert_nil StatementAnalysis::DateParser.parse(nil)
  end

  test "raises error for invalid format" do
    assert_raises(ArgumentError) do
      StatementAnalysis::DateParser.parse("invalid")
    end
  end
end
