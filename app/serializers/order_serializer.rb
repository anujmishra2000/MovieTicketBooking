class OrderSerializer < ActiveModel::Serializer
  attributes :number, :completed_at, :status
  has_many :movies, serializer: MovieSerializer

  def movies
    Movie.where(id: object.line_items.joins(:show).select('shows.movie_id'))
  end
end
