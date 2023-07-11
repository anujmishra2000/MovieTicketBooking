class OrderRefundService
  def initialize(order_id)
    @order = Order.find_by(id: order_id)
    @payment = @order.payments.success.last

  end

  def create_refund(auto_cancelled: nil, cancelled_by_user: nil)
    stripe_refund = Stripe::Refund.create({
      charge: @payment.charge_id
    })
    @order.with_lock do
      @payment.refunds.credited.create(stripe_refund_id: stripe_refund.id, amount: stripe_refund.amount, completed_at: Time.current)
      @order.mark_as_cancelled(auto_cancelled: auto_cancelled, cancelled_by_user: cancelled_by_user)
      line_item = @order.line_items.first
      line_item.show.seats_available += line_item.quantity
      line_item.show.save
    end
  end
end
