class AddNotifyColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :upcoming_movies_alert, :boolean, default: true, null: false, index: true
  end
end
