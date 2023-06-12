class AddIndexToMovieAndTheatre < ActiveRecord::Migration[7.0]
  def change
    add_index :movies, :title, unique: true
    add_index :theatres, :name
  end
end
