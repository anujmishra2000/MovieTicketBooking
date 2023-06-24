class PaymentsController < ApplicationController
  before_action :set_payment, only: [:success, :cancel]

  def create
    begin
      session = StripeService.new(current_user.orders.in_progress.last).create_checkout_session
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      redirect_to root_path, alert: t('.payment_error', error: e.message)
    end
  end

  def success
    session = Stripe::Checkout::Session.retrieve(@payment.session_id)
    ActiveRecord::Base.transaction do
      @payment.update(completed_at: Time.current, payment_intent: session.payment_intent)
      @payment.success!
      @payment.order.update(completed_at: Time.current)
      @payment.order.completed!
    end
    OrderMailer.with(order: @payment.order).confirmed.deliver_later
  rescue => e
    redirect_to root_path, alert: t('.error', error: e.message)
  end

  def cancel
    @payment.failed!
    redirect_to cart_order_path, alert: t('.message')
  end

  private def set_payment
    @payment = Payment.find_by(id: params[:id])
    redirect_to root_path, alert: t('.not_exist') if @payment.nil?
  end

  private def payment_params
    params.require(:payment).permit(:order)
  end
end
