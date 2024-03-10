class Show < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  belongs_to :movie
  belongs_to :theatre

  validates :start_time, :price, presence: true
  validate :no_overlapping_shows
  validate :ensure_not_a_past_show, on: :update

  before_validation :calculate_end_time
  before_create :set_seats_available

  scope :low_occupancy, -> (max_occupied_ratio = 0.2) { joins(:theatre).where("shows.seats_available > (? * theatres.seating_capacity)", (1 - max_occupied_ratio)) }
  scope :next_hour, -> { where(start_time: Time.current..(Time.current + 1.hour)) }

  delegate :name, to: :theatre, prefix: true
  delegate :title, to: :movie, prefix: true

  enum status: {
    'active': 0,
    'cancelled': 1
  }

  def date
    start_time.strftime('%d-%h-%Y')
  end

  private def calculate_end_time
    self.end_time = start_time + movie.duration_in_mins.minutes if start_time
  end

  private def ensure_not_a_past_show
    return unless start_time_was < Time.current
    errors.add(:base, 'Cannot edit past show')
  end

  private def set_seats_available
    self.seats_available = theatre.seating_capacity
  end

  private def no_overlapping_shows
    overlapping_shows = theatre.shows.where.not(id: id).where('(start_time, end_time) OVERLAPS (?, ?)', start_time, end_time)
    return unless overlapping_shows.exists?
    errors.add(:base, 'There is an overlapping show in the same theater.')
  end
end
