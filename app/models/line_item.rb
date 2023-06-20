class LineItem < ApplicationRecord
  belongs_to :show
  belongs_to :order

  validates :quantity, :unit_price, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }, allow_blank: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  before_validation :set_unit_price

  private def set_unit_price
    self.unit_price = show.price
  end
end
