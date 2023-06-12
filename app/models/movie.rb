class Movie < ApplicationRecord
  has_many :shows
  has_many :theatres, through: :shows
  has_one_attached :poster

  validates :title, :release_date, :description, :duration_in_mins, :status, :poster, presence: true
  validates :title, uniqueness: true
  validates :duration_in_mins, numericality: { greater_than: 0, only_integer: true }, allow_blank: true
  validates :description, format: { with: ::DESCRIPTION_REGEX, message: 'must have at least 20 words' }, allow_blank: true
  validates_length_of :title, in: 3..30, message: "should be greater than 3 and less than 30 characters"

  enum status: {
    Upcoming: 0,
    Live: 1,
    Expired: 2
  }

end
