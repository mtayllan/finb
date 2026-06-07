module ApplicationHelper
  FORMATS = {
    "USD" => {
      unit: "$",
      delimiter: ",",
      separator: "."
    },
    "BRL" => {
      unit: "R$",
      delimiter: ".",
      separator: ","
    }
  }.freeze
  def number_to_currency(amount)
    default_currency = Current.user.default_currency
    super(amount, **FORMATS.fetch(default_currency, FORMATS["USD"]))
  end
end
