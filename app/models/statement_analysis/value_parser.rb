class StatementAnalysis::ValueParser
  def self.parse(value_string)
    return 0 if value_string.blank?

    cleaned = value_string.to_s.strip

    # Remove currency symbols (R$, $) if present
    cleaned = cleaned.gsub(/R\$|\$/, "").strip

    # Detect format based on decimal separator
    # If there's a comma followed by exactly 2 digits at the end, it's the decimal separator
    cleaned = if /,\d{2}\z/.match?(cleaned)
      # Format: 1.234,56 (European)
      cleaned.delete(".").tr(",", ".")
    else
      # Format: 1,234.56 (US) or just remove thousand separators
      cleaned.delete(",")
    end

    BigDecimal(cleaned)
  rescue ArgumentError, TypeError
    raise ArgumentError, "Invalid value format: #{value_string}"
  end
end
