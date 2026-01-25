class CreateTransactionTags < ActiveRecord::Migration[8.1]
  def change
    create_table :transaction_tags do |t|
      t.references :transaction, null: false, foreign_key: {on_delete: :cascade}
      t.references :tag, null: false, foreign_key: {on_delete: :cascade}

      t.timestamps
    end

    add_index :transaction_tags, [:transaction_id, :tag_id], unique: true
  end
end
