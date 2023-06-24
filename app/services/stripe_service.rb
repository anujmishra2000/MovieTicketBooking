class StripeService
  def initialize(order)
    @order = Order.find_by(number: order.number)
  end
  def create_checkout_session
    payment = @order.payments.pending.create(amount: @order.total)
    items = load_line_items
    session = Stripe::Checkout::Session.create(
      line_items: items,
      mode: 'payment',
      success_url:  Rails.application.routes.url_helpers.success_payment_url(payment),
      cancel_url: Rails.application.routes.url_helpers.cancel_payment_url(payment)
    )
    payment.update(session_id: session.id)
    session
  end

  def load_line_items
    @order.line_items.map do |line_item|
      {
        quantity: line_item.quantity,
        price_data: {
          currency: 'inr',
          unit_amount_decimal: line_item.unit_price * 100,
          product_data: {
            name: line_item.show.movie.title
          }
        }
      }
    end
  end
end
