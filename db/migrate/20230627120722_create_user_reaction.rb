class CreateUserReaction < ActiveRecord::Migration[7.0]
  def change
    create_table :user_reactions do |t|
      t.integer :status, default: 0, null: false, index: true
      t.references :reactable, polymorphic: true, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
