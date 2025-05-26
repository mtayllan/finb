class AppUI::Accounts::Icon < ViewComponent::Base
  def initialize(account, size: "2xl")
    @account = account
    @size = size
  end

  def call
    render UI::Icon.new(icon, size: @size, background: true, color: @account.color)
  end

  private

  ICONS = {checking: "bank", savings: "piggy-bank", credit_card: "credit-card", investment: "chart-line-up"}.freeze
  def icon
    ICONS[@account.kind.to_sym]
  end
end
