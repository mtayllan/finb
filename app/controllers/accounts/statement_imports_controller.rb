class Accounts::StatementImportsController < ApplicationController
  before_action :set_account
  before_action :set_statement_analysis, only: [:edit, :update, :destroy]
  before_action :prevent_edit_if_completed, only: [:edit, :update, :destroy]

  def new
    @statement_analysis = StatementAnalysis.new(account: @account)
    load_credit_card_statements if @account.credit_card?
  end

  def create
    csv_file = params[:csv_file]

    if csv_file.blank?
      redirect_to new_account_statement_import_path(@account), alert: "Please select a CSV file"
      return
    end

    begin
      analysis_result = StatementAnalysis::CsvAnalyzer.analyze(csv_file)

      @statement_analysis = StatementAnalysis.new(
        account: @account,
        total_rows: analysis_result[:rows].size,
        credit_card_statement_id: params[:credit_card_statement_id]
      )

      if @statement_analysis.save
        create_analysis_items(analysis_result)
        redirect_to edit_account_statement_import_path(@account, @statement_analysis), notice: "CSV analyzed successfully. Review and assign categories."
      else
        load_credit_card_statements if @account.credit_card?
        render :new, status: :unprocessable_content
      end
    rescue StatementAnalysis::CsvAnalyzer::DetectionError => e
      redirect_to new_account_statement_import_path(@account), alert: "CSV analysis failed: #{e.message}"
    end
  end

  def edit
    @categories = Current.user.categories.order(:name)
  end

  def update
    # Update items from params
    if params[:items].present?
      update_items_from_params
    end

    begin
      @statement_analysis.import_transactions!
      redirect_to account_path(@account), notice: "Transactions imported successfully!"
    rescue => e
      @categories = Current.user.categories.order(:name)
      flash.now[:alert] = "Import failed: #{e.message}"
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @statement_analysis.destroy!
    redirect_to account_path(@account), notice: "Import cancelled"
  end

  private

  def set_account
    @account = Current.user.accounts.find(params[:account_id])
  end

  def set_statement_analysis
    @statement_analysis = @account.statement_analyses.find(params[:id])
  end

  def prevent_edit_if_completed
    unless @statement_analysis.can_edit?
      redirect_to account_path(@account), alert: "Cannot modify completed import"
    end
  end

  def load_credit_card_statements
    @credit_card_statements = @account.credit_card_statements.order(month: :desc)
  end

  def create_analysis_items(analysis_result)
    date_col = analysis_result[:date_column]
    value_col = analysis_result[:value_column]
    desc_col = analysis_result[:description_column]

    analysis_result[:rows].each_with_index do |row, index|
      date = StatementAnalysis::DateParser.parse(row[date_col])
      value = StatementAnalysis::ValueParser.parse(row[value_col])
      description = row[desc_col].to_s.strip

      @statement_analysis.items.create!(
        date: date,
        value: value,
        original_description: description,
        description: description,
        row_number: index + 1
      )
    rescue ArgumentError => e
      # Skip rows with invalid data but log them
      Rails.logger.warn("Skipping row #{index + 1}: #{e.message}")
    end
  end

  def update_items_from_params
    params[:items].each do |item_id, item_params|
      item = @statement_analysis.items.find(item_id)
      item.update(
        description: item_params[:description].presence || item.description,
        category_id: item_params[:category_id].presence,
        should_import: item_params[:should_import] == "1"
      )
    end
  end
end
