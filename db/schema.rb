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

ActiveRecord::Schema[7.1].define(version: 2024_06_04_003539) do
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
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color", default: "#000000", null: false
    t.string "icon", default: "", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "account_balances", "accounts", on_delete: :cascade
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transfers", "accounts", column: "origin_account_id"
  add_foreign_key "transfers", "accounts", column: "target_account_id"
end
