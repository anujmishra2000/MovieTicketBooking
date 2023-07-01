class PaymentsController < ApplicationController
  before_action :set_payment, only: [:success, :cancel, :refund]

  def create
    begin
      order = current_user.orders.in_progress.last
      payment = StripeService.create_stripe_charge(order, params[:stripeToken])
      Stripe::Charge.capture(payment.charge_id)
      line_item = order.line_items.first
      begin
        line_item.show.with_lock do
          raise SeatsUnavailableException if line_item.quantity > line_item.show.seats_available
          line_item.show.seats_available -= line_item.quantity
          payment.mark_as_success
          payment.order.mark_as_completed
          line_item.show.save
        end
        redirect_to success_payment_path(payment)
      rescue SeatsUnavailableException
        payment.failed!
        redirect_to root_path, alert: t('.seats_unavailable')
      end
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
