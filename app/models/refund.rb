class Refund < ApplicationRecord
  include Numberable
  set_number(letter:'R', length: 4)

  belongs_to :payment

  validates :status, :amount, :stripe_refund_id, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  enum status: {
    'initiated': 0,
    'credited': 1,
    'failed': 2
  }

end
