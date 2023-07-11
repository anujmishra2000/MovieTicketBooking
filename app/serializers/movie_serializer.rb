class MovieSerializer < ActiveModel::Serializer
  attributes :title, :description, :release_date, :duration_in_mins, :status
end
