class CreatePayment < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :number, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0, null: false
      t.datetime :completed_at
      t.integer :status, null: false
      t.references :order, foreign_key: true, null: false

      t.timestamps
    end
  end
end
