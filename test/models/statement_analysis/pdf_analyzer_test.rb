require "test_helper"

class StatementAnalysis::PdfAnalyzerTest < ActiveSupport::TestCase
  setup do
    ENV["GROQ_API_KEY"] = "test_groq_api_key"
  end

  test "analyzes bank account PDF and returns transactions" do
    file = create_test_pdf_file
    groq_transactions = [
      {"date" => "2025-01-15", "description" => "Grocery", "value" => -100.50},
      {"date" => "2025-01-16", "description" => "Salary", "value" => 5000.00}
    ]

    mock_pdf_reader("Bank Statement\n01/15/2025 Grocery -100.50")
    stub_groq_api(groq_transactions)

    result = StatementAnalysis::PdfAnalyzer.analyze(file, is_credit_card: false)

    assert_equal 2, result[:transactions].size
    assert_equal Date.parse("2025-01-15"), result[:transactions][0][:date]
    assert_equal "Grocery", result[:transactions][0][:description]
    assert_equal(-100.50, result[:transactions][0][:value])
  end

  test "analyzes credit card PDF with positive values for expenses" do
    file = create_test_pdf_file
    groq_transactions = [
      {"date" => "2025-01-15", "description" => "Grocery", "value" => 100.50},
      {"date" => "2025-01-16", "description" => "Refund", "value" => -50.00}
    ]

    mock_pdf_reader("Credit Card Statement")
    stub_groq_api(groq_transactions)

    result = StatementAnalysis::PdfAnalyzer.analyze(file, is_credit_card: true)

    assert_equal 2, result[:transactions].size
    assert_equal 100.50, result[:transactions][0][:value]
    assert_equal(-50.00, result[:transactions][1][:value])
  end

  test "handles Groq response with surrounding text" do
    file = create_test_pdf_file
    json_array = [{"date" => "2025-01-15", "description" => "Test", "value" => -50.00}]
    wrapped_content = "Here are the transactions:\n#{JSON.generate(json_array)}\nHope this helps!"

    mock_pdf_reader("Statement text")
    stub_groq_api_raw(wrapped_content)

    result = StatementAnalysis::PdfAnalyzer.analyze(file)

    assert_equal 1, result[:transactions].size
    assert_equal "Test", result[:transactions][0][:description]
  end

  test "raises error when GROQ_API_KEY is not configured" do
    ENV.delete("GROQ_API_KEY")
    file = create_test_pdf_file

    mock_pdf_reader("Statement text")

    error = assert_raises(StatementAnalysis::PdfAnalyzer::DetectionError) do
      StatementAnalysis::PdfAnalyzer.analyze(file)
    end

    assert_includes error.message, "GROQ_API_KEY not configured"
    assert_includes error.message, "https://console.groq.com/"
  end

  test "raises error when Groq returns invalid JSON" do
    file = create_test_pdf_file

    mock_pdf_reader("Statement text")
    stub_groq_api_raw("Not valid JSON")

    error = assert_raises(StatementAnalysis::PdfAnalyzer::DetectionError) do
      StatementAnalysis::PdfAnalyzer.analyze(file)
    end

    assert_includes error.message, "Could not find JSON array"
  end

  test "raises error when Groq API fails" do
    file = create_test_pdf_file

    mock_pdf_reader("Statement text")
    stub_request(:post, "https://api.groq.com/openai/v1/chat/completions")
      .to_return(status: 500, body: '{"error": "Server error"}')

    error = assert_raises(StatementAnalysis::PdfAnalyzer::DetectionError) do
      StatementAnalysis::PdfAnalyzer.analyze(file)
    end

    assert_includes error.message, "Groq API error"
  end

  test "raises error when no transactions found" do
    file = create_test_pdf_file

    mock_pdf_reader("Statement text")
    stub_groq_api([])

    error = assert_raises(StatementAnalysis::PdfAnalyzer::DetectionError) do
      StatementAnalysis::PdfAnalyzer.analyze(file)
    end

    assert_includes error.message, "No transactions found"
  end

  test "raises error when PDF has no text content" do
    file = create_test_pdf_file

    mock_pdf_reader("")

    error = assert_raises(StatementAnalysis::PdfAnalyzer::DetectionError) do
      StatementAnalysis::PdfAnalyzer.analyze(file)
    end

    assert_includes error.message, "Could not extract text from PDF"
  end

  private

  def create_test_pdf_file
    Tempfile.new(["test", ".pdf"]).tap(&:close)
  end

  def mock_pdf_reader(text)
    page = Object.new
    page.define_singleton_method(:text) { text }

    reader = Object.new
    reader.define_singleton_method(:pages) { [page] }

    PDF::Reader.define_singleton_method(:new) do |_path, _options = {}|
      reader
    end
  end

  def stub_groq_api(transactions)
    stub_groq_api_raw(JSON.generate(transactions))
  end

  def stub_groq_api_raw(content)
    response_body = {
      "choices" => [
        {"message" => {"content" => content}}
      ]
    }

    stub_request(:post, "https://api.groq.com/openai/v1/chat/completions")
      .to_return(
        status: 200,
        body: response_body.to_json,
        headers: {"Content-Type" => "application/json"}
      )
  end
end
