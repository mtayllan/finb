class CreateCreditCards < ActiveRecord::Migration[8.0]
  def change
    create_table :credit_cards do |t|
      t.string :name, null: false
      t.decimal :limit, null: false, precision: 10, scale: 2
      t.string :color, null: false
      t.integer :due_day, null: false
      t.integer :closing_day, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
