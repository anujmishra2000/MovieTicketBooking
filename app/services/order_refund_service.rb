class OrderRefundService
  def initialize(payment)
    @payment = payment
    @order = @payment.order
  end

  def create_refund(auto_cancelled: nil, cancelled_by_user: nil)
    stripe_refund = Stripe::Refund.create({
      charge: @payment.charge_id
    })
    @order.with_lock do
      @payment.refunds.credited.create(stripe_refund_id: stripe_refund.id, amount: stripe_refund.amount, completed_at: Time.current)
      @order.mark_as_cancelled(auto_cancelled: auto_cancelled, cancelled_by_user: cancelled_by_user)
    end
  end
end
