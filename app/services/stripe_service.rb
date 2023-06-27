class StripeService
  def self.create_stripe_charge(order, token)
    payment = order.payments.pending.create(amount: order.total)
    charge = Stripe::Charge.create({source: token,amount: order.total.to_i,currency: 'usd',capture: false})
    payment.update(charge_id: charge.id)
    payment
  end

  def self.create_refund(payment)
    payment_intent = Stripe::PaymentIntent.retrieve(payment.payment_intent)
    Stripe::Refund.create({
      payment_intent: payment_intent
    })
  end
end
