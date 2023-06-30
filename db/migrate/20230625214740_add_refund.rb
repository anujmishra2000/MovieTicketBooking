class AddRefund < ActiveRecord::Migration[7.0]
  def change
    create_table :refunds do |t|
      t.string :number, null: false, index: { unique: true }
      t.decimal :amount, precision: 10, scale: 2, default: 0, null: false
      t.datetime :completed_at, index: true
      t.string :stripe_refund_id, index: true
      t.integer :status, default: 0, null: false, index: true
      t.references :payment, foreign_key: true, null: false

      t.timestamps
    end
  end
end
