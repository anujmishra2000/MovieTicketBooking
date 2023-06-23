class CreateLineItem < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity, default: 0, null: false
      t.decimal :unit_price, precision: 10, scale: 2, default: 0, null: false
      t.references :show, foreign_key: true, null: false
      t.references :order, foreign_key: true, null: false

      t.timestamps
    end
  end
end
