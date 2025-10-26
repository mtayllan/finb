require "test_helper"

class StatementAnalysis::CsvAnalyzerTest < ActiveSupport::TestCase
  test "analyzes simple CSV with comma delimiter" do
    csv_content = <<~CSV
      Date,Description,Amount
      01/01/2024,Grocery Store,-50.00
      02/01/2024,Salary,1000.00
    CSV

    file = StringIO.new(csv_content)

    result = StatementAnalysis::CsvAnalyzer.analyze(file)

    assert_equal 0, result[:date_column]
    assert_equal 1, result[:description_column]
    assert_equal 2, result[:value_column]
    assert_equal 2, result[:rows].size
  end

  test "analyzes CSV with European number format (quoted)" do
    csv_content = <<~CSV
      Date,Description,Amount
      01/01/2024,Grocery Store,"-50,00"
      02/01/2024,Salary,"1000,00"
    CSV

    file = StringIO.new(csv_content)

    result = StatementAnalysis::CsvAnalyzer.analyze(file)

    assert_equal 0, result[:date_column]
    assert_equal 1, result[:description_column]
    assert_equal 2, result[:value_column]
    assert_equal 2, result[:rows].size
  end

  test "raises error for empty CSV" do
    csv_content = ""
    file = StringIO.new(csv_content)

    assert_raises(StatementAnalysis::CsvAnalyzer::DetectionError) do
      StatementAnalysis::CsvAnalyzer.analyze(file)
    end
  end

  test "raises error for CSV with only headers" do
    csv_content = "Date,Description,Amount\n"
    file = StringIO.new(csv_content)

    assert_raises(StatementAnalysis::CsvAnalyzer::DetectionError) do
      StatementAnalysis::CsvAnalyzer.analyze(file)
    end
  end

  test "handles CSV with UTF-8 BOM" do
    # UTF-8 BOM is \xEF\xBB\xBF
    csv_content = "\xEF\xBB\xBFDate,Description,Amount\n01/01/2024,Grocery Store,-50.00\n02/01/2024,Salary,1000.00"
    file = StringIO.new(csv_content)

    result = StatementAnalysis::CsvAnalyzer.analyze(file)

    assert_equal 0, result[:date_column]
    assert_equal 1, result[:description_column]
    assert_equal 2, result[:value_column]
    assert_equal 2, result[:rows].size
  end

  test "handles CSV with non-breaking spaces in values" do
    # Non-breaking space is \u00A0 (UTF-8: 0xC2 0xA0)
    csv_content = "Date,Description,Amount\n01/01/2024,Grocery Store,\"R$\u00A031,98\"\n02/01/2024,Salary,\"R$\u00A01.000,00\""
    file = StringIO.new(csv_content)

    result = StatementAnalysis::CsvAnalyzer.analyze(file)

    assert_equal 0, result[:date_column]
    assert_equal 1, result[:description_column]
    assert_equal 2, result[:value_column]
    assert_equal 2, result[:rows].size
  end
end
