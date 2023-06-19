class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :theatre

  validates :start_time, :end_time, :price, presence: true
  validate :no_overlapping_shows
  validate :ensure_not_a_past_show, on: :update

  before_validation :calculate_end_time

  enum status: {
    'active': 0,
    'cancelled': 1
  }

  def date
    start_time.strftime('%d-%h-%Y')
  end

  def time_in_12_hour_format(time)
    time.strftime('%I:%M %p')
  end

  private def calculate_end_time
    self.end_time = start_time + movie.duration_in_mins.minutes
  end

  private def ensure_not_a_past_show
    return unless start_time_was < Time.current
    errors.add(:base, 'Cannot edit past show')
  end

  private def no_overlapping_shows
    overlapping_shows = theatre.shows.where.not(id: id).where('(start_time, end_time) OVERLAPS (?, ?)', start_time, end_time)
    return unless overlapping_shows.exists?
    errors.add(:base, 'There is an overlapping show in the same theater.')
  end
end
