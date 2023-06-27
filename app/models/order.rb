class Order < ApplicationRecord
  include Numberable
  set_number(letter:'O', length: 6)
  has_many :line_items, dependent: :restrict_with_error
  has_many :payments, dependent: :restrict_with_error
  belongs_to :user
  belongs_to :cancelled_by_user, class_name: 'User', optional: true

  validates :status, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  scope :sort_by_most_recent, -> { order(completed_at: :desc) }

  enum status: {
    'in_progress': 0,
    'completed': 1,
    'cancelled': 2
  }

  def cancellable?
    return true if (6.hours.from_now < earliest_show_start_time)
    errors.add(:base, 'Show start time is less than 6 hours')
    false
  end

  def earliest_show_start_time
    line_items.joins(:show).minimum(:start_time)
  end

  def to_param
    number
  end

  def calculate_total
    line_items.sum('quantity * unit_price')
  end

  def marked_as_completed
    update(completed_at: Time.current)
    completed!
    OrderMailer.with(order: self).confirmed.deliver_later
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["status"]
  end
end
