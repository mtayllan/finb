# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_24_195149) do
  create_table "account_balances", force: :cascade do |t|
    t.integer "account_id", null: false
    t.decimal "balance", precision: 19, scale: 2, null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "date"], name: "index_account_balances_on_account_id_and_date", unique: true
    t.index ["account_id"], name: "index_account_balances_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.decimal "balance", precision: 9, scale: 2, default: "0.0", null: false
    t.string "color", default: "#000000", null: false
    t.datetime "created_at", null: false
    t.integer "credit_card_expiration_day"
    t.decimal "initial_balance", precision: 9, scale: 2, default: "0.0", null: false
    t.date "initial_balance_date", null: false
    t.integer "kind", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "color", default: "#000000", null: false
    t.datetime "created_at", null: false
    t.string "icon", default: "", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "credit_card_statements", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.date "month", null: false
    t.date "paid_at"
    t.datetime "updated_at", null: false
    t.decimal "value", default: "0.0"
    t.index ["account_id"], name: "index_credit_card_statements_on_account_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "splits", force: :cascade do |t|
    t.decimal "amount_borrowed", null: false
    t.integer "borrower_id", null: false
    t.integer "borrower_transaction_id"
    t.date "confirmed_at"
    t.datetime "created_at", null: false
    t.integer "payer_transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_id"], name: "index_splits_on_borrower_id"
    t.index ["borrower_transaction_id"], name: "index_splits_on_borrower_transaction_id", unique: true, where: "borrower_transaction_id IS NOT NULL"
    t.index ["payer_transaction_id"], name: "index_splits_on_payer_transaction_id", unique: true
  end

  create_table "statement_analyses", force: :cascade do |t|
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.integer "credit_card_statement_id"
    t.integer "status", default: 0, null: false
    t.integer "total_rows", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_statement_analyses_on_account_id"
    t.index ["credit_card_statement_id"], name: "index_statement_analyses_on_credit_card_statement_id"
  end

  create_table "statement_analysis_items", force: :cascade do |t|
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "description", null: false
    t.string "original_description"
    t.integer "row_number", null: false
    t.boolean "should_import", default: true, null: false
    t.integer "statement_analysis_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 9, scale: 2, null: false
    t.index ["category_id"], name: "index_statement_analysis_items_on_category_id"
    t.index ["statement_analysis_id"], name: "index_statement_analysis_items_on_statement_analysis_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "color", default: "#000000", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "transaction_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "tag_id", null: false
    t.integer "transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_transaction_tags_on_tag_id"
    t.index ["transaction_id", "tag_id"], name: "index_transaction_tags_on_transaction_id_and_tag_id", unique: true
    t.index ["transaction_id"], name: "index_transaction_tags_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id"
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "credit_card_statement_id"
    t.date "date", null: false
    t.string "description"
    t.boolean "exclude_from_reports", default: false, null: false
    t.boolean "from_split", default: false
    t.decimal "report_value", precision: 9, scale: 2
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 9, scale: 2, default: "0.0", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["credit_card_statement_id"], name: "index_transactions_on_credit_card_statement_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "description"
    t.integer "origin_account_id", null: false
    t.integer "target_account_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.index ["origin_account_id"], name: "index_transfers_on_origin_account_id"
    t.index ["target_account_id"], name: "index_transfers_on_target_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "default_currency", default: "USD", null: false
    t.string "password_digest", null: false
    t.boolean "superuser", default: false
    t.string "username", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "account_balances", "accounts", on_delete: :cascade
  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "credit_card_statements", "accounts"
  add_foreign_key "sessions", "users", on_delete: :cascade
  add_foreign_key "splits", "transactions", column: "borrower_transaction_id"
  add_foreign_key "splits", "transactions", column: "payer_transaction_id"
  add_foreign_key "splits", "users", column: "borrower_id"
  add_foreign_key "statement_analyses", "accounts"
  add_foreign_key "statement_analyses", "credit_card_statements"
  add_foreign_key "statement_analysis_items", "categories"
  add_foreign_key "statement_analysis_items", "statement_analyses"
  add_foreign_key "tags", "users"
  add_foreign_key "transaction_tags", "tags", on_delete: :cascade
  add_foreign_key "transaction_tags", "transactions", on_delete: :cascade
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "credit_card_statements"
  add_foreign_key "transfers", "accounts", column: "origin_account_id"
  add_foreign_key "transfers", "accounts", column: "target_account_id"
end
