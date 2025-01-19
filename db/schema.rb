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

ActiveRecord::Schema[8.0].define(version: 2025_01_19_174433) do
  create_table "account_balances", force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "date", null: false
    t.decimal "balance", precision: 19, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "date"], name: "index_account_balances_on_account_id_and_date", unique: true
    t.index ["account_id"], name: "index_account_balances_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "initial_balance", precision: 9, scale: 2, default: "0.0", null: false
    t.decimal "balance", precision: 9, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "#000000", null: false
    t.integer "kind", default: 0, null: false
    t.date "initial_balance_date", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "#000000", null: false
    t.string "icon", default: "", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "credit_card_statements", force: :cascade do |t|
    t.integer "credit_card_id", null: false
    t.datetime "paid_at"
    t.datetime "due_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_card_id"], name: "index_credit_card_statements_on_credit_card_id"
  end

  create_table "credit_card_transaction_installments", force: :cascade do |t|
    t.integer "original_transaction_id", null: false
    t.integer "statement_id", null: false
    t.decimal "value", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_transaction_id"], name: "idx_on_original_transaction_id_bf7530c8b6"
    t.index ["statement_id"], name: "index_credit_card_transaction_installments_on_statement_id"
  end

  create_table "credit_card_transactions", force: :cascade do |t|
    t.integer "statement_id", null: false
    t.decimal "value", null: false
    t.integer "total_installments", null: false
    t.integer "category_id", null: false
    t.string "description", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_credit_card_transactions_on_category_id"
    t.index ["statement_id"], name: "index_credit_card_transactions_on_statement_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "expiration_day", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_credit_cards_on_account_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description"
    t.decimal "value", precision: 9, scale: 2, default: "0.0", null: false
    t.integer "category_id", null: false
    t.integer "account_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "origin_account_id", null: false
    t.integer "target_account_id", null: false
    t.string "description"
    t.decimal "value", precision: 10, scale: 2, null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["origin_account_id"], name: "index_transfers_on_origin_account_id"
    t.index ["target_account_id"], name: "index_transfers_on_target_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "account_balances", "accounts", on_delete: :cascade
  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "credit_card_statements", "credit_cards"
  add_foreign_key "credit_card_transaction_installments", "credit_card_statements", column: "statement_id"
  add_foreign_key "credit_card_transaction_installments", "credit_card_transactions", column: "original_transaction_id"
  add_foreign_key "credit_card_transactions", "categories"
  add_foreign_key "credit_card_transactions", "credit_card_statements", column: "statement_id"
  add_foreign_key "credit_cards", "accounts"
  add_foreign_key "sessions", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transfers", "accounts", column: "origin_account_id"
  add_foreign_key "transfers", "accounts", column: "target_account_id"
end
