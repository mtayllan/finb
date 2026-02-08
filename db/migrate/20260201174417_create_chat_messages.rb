class CreateChatMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :chat_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message, null: false
      t.text :response
      t.references :created_transaction, foreign_key: {to_table: :transactions}

      t.timestamps
    end
  end
end
