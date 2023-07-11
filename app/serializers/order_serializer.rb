class OrderSerializer < ActiveModel::Serializer
  attributes :number, :completed_at, :status
  has_many :movies, serializer: MovieSerializer

  def movies
    object.line_items.map { |line_item| line_item.show.movie }
  end
end
