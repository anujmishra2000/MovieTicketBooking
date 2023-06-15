class AddIndexToMoviesDescription < ActiveRecord::Migration[7.0]
  def change
    add_index :movies, "description gin_trgm_ops", using: :gin, name: 'trgm_idx_movies_description'
  end
end
