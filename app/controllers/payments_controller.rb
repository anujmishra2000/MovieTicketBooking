class PaymentsController < ApplicationController
  before_action :set_payment, only: [:success, :cancel, :refund]
  before_action :set_order, only: :create

  def create
    begin
      order = current_user.orders.in_progress.last
      payment = StripeService.create_stripe_charge(order, params[:stripeToken])
      Stripe::Charge.capture(payment.charge_id)
      payment.marked_as_success
      payment.order.marked_as_completed
      redirect_to success_payment_path(payment)
    rescue Stripe::StripeError => e
      current_user.orders.in_progress.first.payments.last.failed!
      redirect_to request.referrer, alert: t('.payment_error', error: e.message)
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
