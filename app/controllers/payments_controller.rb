class PaymentsController < ApplicationController
  before_action :set_payment, only: [:success, :cancel, :refund]

  def create
    order = current_user.orders.in_progress.last
    begin
      payment = StripeService.create_stripe_charge(order, params[:stripeToken])
    rescue Stripe::StripeError => e
      current_user.orders.in_progress.first.payments.last.failed!
      return redirect_to cart_order_path(order), alert: t('.payment_error', error: e.message)
    end
      line_item = order.line_items.first
      show = line_item.show
    begin
      show.with_lock do
        raise SeatsUnavailableException if line_item.quantity > show.seats_available
        Stripe::Charge.capture(payment.charge_id)
        show.seats_available -= line_item.quantity
        payment.mark_as_success
        payment.order.mark_as_completed
        show.save
      end
      redirect_to success_payment_path(payment)
    rescue SeatsUnavailableException
      payment.failed!
      redirect_to root_path, alert: t('.seats_unavailable')
    end
  end

  private def set_payment
    @payment = Payment.find_by(id: params[:id])
    redirect_to root_path, alert: t('.not_exist') if @payment.nil?
  end

  private def payment_params
    params.require(:payment).permit(:order)
  end
end
