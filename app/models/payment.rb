class Payment < ApplicationRecord
  include Numberable
  set_number(letter:'P', length: 6)

  has_many :refunds
  belongs_to :order

  validates :status, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  enum status: {
    'pending': 0,
    'success': 1,
    'failed': 2
  }

  def marked_as_success
    update(completed_at: Time.current)
    success!
  end
end
