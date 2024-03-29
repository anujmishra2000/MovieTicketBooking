class Movie < ApplicationRecord
  has_many :shows, dependent: :restrict_with_error
  has_many :theatres, through: :shows
  has_many :user_reactions, as: :reactable
  has_one_attached :poster

  validates :title, :release_date, :description, :duration_in_mins, :status, :poster, presence: true
  validates :title, uniqueness: true
  validates :duration_in_mins, numericality: { greater_than: 0, only_integer: true }, allow_blank: true
  validates :description, format: { with: ::DESCRIPTION_REGEX, message: 'must have at least 20 words' }, allow_blank: true
  validates_length_of :title, in: 3..30, message: "should be greater than 3 and less than 30 characters"

  enum status: {
    'upcoming': 0,
    'live': 1,
    'expired': 2
  }

  def self.ransackable_associations(auth_object = nil)
    ["poster_attachment", "poster_blob", "shows", "theatres"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "description", "status"]
  end
end
