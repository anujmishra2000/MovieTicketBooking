class CreatePayment < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :number, null: false, index: { unique: true }
      t.decimal :amount, precision: 10, scale: 2, default: 0, null: false
      t.datetime :completed_at, index: true
      t.integer :status, default: 0, null: false, index: true
      t.string :session_id, index: true
      t.string :payment_intent, index: true
      t.references :order, foreign_key: true, null: false

      t.timestamps
    end
  end
end
