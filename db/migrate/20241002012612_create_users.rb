class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
    end

    add_index :users, :username, unique: true
    add_reference :sessions, :user, foreign_key: true, null: false
    add_reference :accounts, :user, foreign_key: true, null: false
    add_reference :categories, :user, foreign_key: true, null: false
  end
end
