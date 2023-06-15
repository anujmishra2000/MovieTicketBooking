class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :theatre

  validates :start_time, :end_time, :price, presence: true
  validate :no_overlapping_shows

  before_validation :calculate_end_time

  scope :by_date, -> (from, to) { where(start_time: (from..(to.to_date.end_of_day.to_s))) }

  enum status: {
    'active': 0,
    'cancelled': 1
  }

  def date
    start_time.strftime('%d-%h-%Y')
  end

  private def calculate_end_time
    self.end_time = start_time + movie.duration_in_mins.minutes
  end

  private def no_overlapping_shows
    overlapping_shows = theatre.shows.where.not(id: id).where('(start_time, end_time) OVERLAPS (?, ?)', start_time, end_time)
    return unless overlapping_shows.exists?
    errors.add(:base, 'There is an overlapping show in the same theater.')
  end
end
