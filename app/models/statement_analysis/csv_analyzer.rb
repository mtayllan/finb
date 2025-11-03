require "csv"

class StatementAnalysis::CsvAnalyzer
  class DetectionError < StandardError; end

  DATE_PATTERNS = [
    /\A\d{1,2}[\/-]\d{1,2}[\/-]\d{2,4}\z/,  # DD/MM/YYYY or DD-MM-YYYY
    /\A\d{4}[\/-]\d{1,2}[\/-]\d{1,2}\z/,    # YYYY-MM-DD or YYYY/MM/DD
    /\A\d{1,2}\s+\w+\s+\d{4}\z/                # DD Month YYYY
  ].freeze

  VALUE_PATTERNS = [
    /\A(R\$|\$)?\s*-?\d{1,3}([.,]\d{3})*[.,]\d{2}\z/,   # R$ 1.234,56 or $ 1,234.56
    /\A(R\$|\$)?\s*-?\d+[.,]\d{2}\z/,                   # R$ 123,56 or $ 123.56
    /\A-?\d{1,3}([.,]\d{3})*[.,]\d{2}\s*(R\$|\$)?\z/,   # 1.234,56 R$ or 1,234.56 $
    /\A-?\d+[.,]\d{2}\s*(R\$|\$)?\z/                    # 123,56 R$ or 123.56 $
  ].freeze

  def self.analyze(file, delimiter: ",")
    new(file, delimiter: delimiter).analyze
  end

  def initialize(file, delimiter: ",")
    @file = file
    @delimiter = delimiter
  end

  def analyze
    content = @file.read
    content = clear_content(content)
    rows = parse_csv(content)

    raise DetectionError, "CSV file is empty or has only headers" if rows.size < 2

    data_rows = rows[1..]

    date_column = detect_date_column(data_rows)
    value_column = detect_value_column(data_rows)
    description_column = detect_description_column(data_rows, [date_column, value_column])

    raise DetectionError, "Could not detect required columns" if date_column.nil? || value_column.nil? || description_column.nil?

    {
      date_column: date_column,
      value_column: value_column,
      description_column: description_column,
      rows: data_rows
    }
  end

  private

  def clear_content(content)
    # Remove UTF-8 BOM if present
    # Force encoding to UTF-8 first, then remove BOM bytes
    content = content.force_encoding("UTF-8")
    content = content.sub("\uFEFF", "") # Unicode BOM character

    # Replace non-breaking spaces and other whitespace variants with regular space
    # \u00A0 = non-breaking space (byte 194 160 in UTF-8)
    # \u2007 = figure space
    # \u202F = narrow non-breaking space
    content.gsub(/[\u00A0\u2007\u202F]/, " ")
  end

  def parse_csv(content)
    CSV.parse(content, col_sep: @delimiter, skip_blanks: true)
  rescue CSV::MalformedCSVError => e
    raise DetectionError, "Failed to parse CSV: #{e.message}"
  end

  def detect_date_column(rows)
    return nil if rows.empty?

    column_count = rows.first.size

    (0...column_count).each do |col_idx|
      date_matches = rows.count do |row|
        cell = row[col_idx].to_s.strip
        DATE_PATTERNS.any? { |pattern| cell.match?(pattern) }
      end

      # If more than 80% of rows match date patterns
      return col_idx if date_matches.to_f / rows.size > 0.8
    end

    nil
  end

  def detect_value_column(rows)
    return nil if rows.empty?

    column_count = rows.first.size

    (0...column_count).each do |col_idx|
      value_matches = rows.count do |row|
        cell = row[col_idx].to_s.strip
        VALUE_PATTERNS.any? { |pattern| cell.match?(pattern) }
      end

      # If more than 80% of rows match value patterns
      return col_idx if value_matches.to_f / rows.size > 0.8
    end

    nil
  end

  def detect_description_column(rows, excluded_columns)
    return nil if rows.empty?

    column_count = rows.first.size
    available_columns = (0...column_count).to_a - excluded_columns.compact

    return nil if available_columns.empty?

    # Find column with longest average string length
    available_columns.max_by do |col_idx|
      total_length = rows.sum { |row| row[col_idx].to_s.length }
      total_length.to_f / rows.size
    end
  end
end
