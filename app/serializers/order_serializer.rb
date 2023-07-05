class OrderSerializer < ActiveModel::Serializer
  attributes :number, :completed_at, :movies

  def movies
    object.line_items.map do |line_item|
      movie = line_item.show.movie
      {
        title: movie.title,
        description: movie.description
      }
    end
  end
end
