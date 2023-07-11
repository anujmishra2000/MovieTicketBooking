class AddSeatsAvailableColumnInShow < ActiveRecord::Migration[7.0]
  def change
    add_column :shows, :seats_available, :integer, default: 0, null: false, index: true
  end
end
