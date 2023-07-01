class LineItem < ApplicationRecord
  belongs_to :show
  belongs_to :order

  validates :quantity, :unit_price, presence: true
  validates :quantity, numericality: { greater_than: 0, only_integer: true }, allow_blank: true
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, message: 'must be a valid decimal number' }, allow_blank: true

  before_validation :set_unit_price
  after_commit :update_order_total
  validate :validate_seats_availability

  private def set_unit_price
    return unless show_id.present?
    self.unit_price = show.price
  end

  private def update_order_total
    order.update(total: order.calculate_total)
  end

  private def validate_seats_availability
    if quantity > show.seats_available
      order.errors.add(:base, "Quantity cannot be greater than available seats")
    end
  end
end
