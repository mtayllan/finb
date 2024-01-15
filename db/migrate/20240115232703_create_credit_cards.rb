class CreateCreditCards < ActiveRecord::Migration[7.1]
  def change
    create_table :credit_cards do |t|
      t.string :name, null: false
      t.integer :due_day, null: false
      t.integer :close_day, null: false
      t.string :color, null: false

      t.timestamps
    end
  end
end
