class CreateShow < ActiveRecord::Migration[7.0]
  def change
    create_table :shows do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.decimal :price, null: false
      t.integer :status, null: false
      t.references :theatre, foreign_key: true, null: false
      t.references :movie, foreign_key: true, null: false

      t.timestamps
    end
  end
end
