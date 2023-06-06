class CreateAddress < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.integer :pincode, null: false
      t.references :theatre, foreign_key: true, null: false
      t.references :address, foreign_key: true, null: false

      t.timestamps
    end
  end
end
