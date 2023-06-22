class StripeService
  def create_checkout_session(order_number)
    order = Order.find_by(number: order_number)
    payment = order.payments.create(amount: order.total, status: 'pending')
    items = order.line_items.map do |line_item|
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
    Stripe::Checkout::Session.create(
      line_items: items,
      mode: 'payment',
      success_url:  Rails.application.routes.url_helpers.success_payment_url(payment),
      cancel_url: Rails.application.routes.url_helpers.cancel_payment_url(payment)
    )
  end
end
