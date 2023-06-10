class CreateMovie < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.date :release_date, null: false
      t.text :description, null: false
      t.integer :duration_in_mins, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
