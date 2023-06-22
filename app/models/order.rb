class Order < ApplicationRecord
  include Numberable
  set_number(letter:'O', length: 6)
  has_many :line_items, dependent: :restrict_with_error
  has_many :payments, dependent: :restrict_with_error
  belongs_to :user
  belongs_to :cancelled_by_user, class_name: 'User', optional: true

  validates :status, :total, presence: true
  validates :total, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true


  enum status: {
    'in_progress': 0,
    'completed': 1,
    'cancelled': 2
  }

  def to_param
    number
  end

  def calculate_total
    line_items.sum('quantity * unit_price')
  end
end
