class CreateOrder < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :total, default: 0, null: false
      t.datetime :completed_at
      t.datetime :cancelled_at
      t.string :number, null: false
      t.boolean :auto_cancellation
      t.integer :status, default: 0, null: false
      t.references :user, foreign_key: true, null: false
      t.references :cancelled_by_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
