require "test_helper"

class StatementAnalysis::ValueParserTest < ActiveSupport::TestCase
  test "parses US format (1,234.56)" do
    assert_equal BigDecimal("1234.56"), StatementAnalysis::ValueParser.parse("1,234.56")
  end

  test "parses European format (1.234,56)" do
    assert_equal BigDecimal("1234.56"), StatementAnalysis::ValueParser.parse("1.234,56")
  end

  test "parses simple decimal (123.45)" do
    assert_equal BigDecimal("123.45"), StatementAnalysis::ValueParser.parse("123.45")
  end

  test "parses negative values" do
    assert_equal BigDecimal("-50.00"), StatementAnalysis::ValueParser.parse("-50.00")
  end

  test "parses values without decimals" do
    assert_equal BigDecimal(100), StatementAnalysis::ValueParser.parse("100")
  end

  test "returns 0 for blank values" do
    assert_equal BigDecimal(0), StatementAnalysis::ValueParser.parse("")
    assert_equal BigDecimal(0), StatementAnalysis::ValueParser.parse(nil)
  end

  test "raises error for invalid format" do
    assert_raises(ArgumentError) do
      StatementAnalysis::ValueParser.parse("abc")
    end
  end

  test "parses values with dollar symbol" do
    assert_equal BigDecimal("123.45"), StatementAnalysis::ValueParser.parse("$ 123.45")
    assert_equal BigDecimal("123.45"), StatementAnalysis::ValueParser.parse("123.45 $")
    assert_equal BigDecimal("-50.00"), StatementAnalysis::ValueParser.parse("$ -50.00")
    assert_equal BigDecimal("1234.56"), StatementAnalysis::ValueParser.parse("$1,234.56")
  end

  test "parses values with BRL symbol (R$)" do
    assert_equal BigDecimal("123.45"), StatementAnalysis::ValueParser.parse("R$ 123,45")
    assert_equal BigDecimal("123.45"), StatementAnalysis::ValueParser.parse("123,45 R$")
    assert_equal BigDecimal("-50.00"), StatementAnalysis::ValueParser.parse("R$ -50,00")
    assert_equal BigDecimal("1234.56"), StatementAnalysis::ValueParser.parse("R$1.234,56")
  end
end
