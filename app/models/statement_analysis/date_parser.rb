class StatementAnalysis::DateParser
  DATE_FORMATS = [
    "%d/%m/%Y",   # 31/12/2024
    "%d-%m-%Y",   # 31-12-2024
    "%d/%m/%y",   # 31/12/24
    "%d-%m-%y",   # 31-12-24
    "%Y-%m-%d",   # 2024-12-31
    "%Y/%m/%d",   # 2024/12/31
    "%d %B %Y",   # 31 December 2024
    "%d %b %Y"    # 31 Dec 2024
  ].freeze

  def self.parse(date_string)
    return nil if date_string.blank?

    cleaned = date_string.to_s.strip

    DATE_FORMATS.each do |format|
      return Date.strptime(cleaned, format)
    rescue ArgumentError
      next
    end

    # Try standard Date.parse as fallback
    Date.parse(cleaned)
  rescue ArgumentError, TypeError
    raise ArgumentError, "Invalid date format: #{date_string}"
  end
end
