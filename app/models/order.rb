class Order < ApplicationRecord
  include Numberable

  has_many :line_items, dependent: :restrict_with_error
  belongs_to :user
  belongs_to :cancelled_by_user, class_name: 'User', optional: true

  validates :status, :total, presence: true
  validates :number, presence: true, uniqueness: true
  validates :total, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  before_validation :set_number
  before_save :calculate_total

  enum status: {
    'in_progress': 0,
    'completed': 1,
    'cancelled': 2
  }

  def to_param
    number
  end

  private def calculate_total
    self.total = line_items.sum(0) { |line_item| line_item.quantity * line_item.unit_price }
  end

  private def set_number
    generate_number('O', 7)
  end
end
