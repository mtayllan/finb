class ChangeSessionReferenceToCascade < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :sessions, :users
    add_foreign_key :sessions, :users, on_delete: :cascade
  end
end
