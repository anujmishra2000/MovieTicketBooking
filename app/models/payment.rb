class Payment < ApplicationRecord
  include Numberable

  belongs_to :order

  validates :status, :amount, presence: true
  validates :number, presence: true, uniqueness: true
  validates :amount, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  before_validation :set_number

  enum status: {
    'pending': 0,
    'success': 1,
    'failed': 2
  }

  private def set_number
    generate_number('P', 8)
  end
end
