class CreateTheatre < ActiveRecord::Migration[7.0]
  def change
    create_table :theatres do |t|
      t.string :name, null: false
      t.integer :screen_type, null: false
      t.integer :seating_capacity, null: false
      t.boolean :operational, null: false, default: false
      t.string :contact_number, null: false
      t.string :contact_email, null: false

      t.timestamps
    end
  end
end
