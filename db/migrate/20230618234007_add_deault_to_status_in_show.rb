class AddDeaultToStatusInShow < ActiveRecord::Migration[7.0]
  def change
    change_column_default :shows, :status, from: nil, to: 0
  end
end
