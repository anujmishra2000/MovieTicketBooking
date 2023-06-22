class PaymentsController < ApplicationController
  before_action :set_payment, only: [:success, :cancel]

  def create
    begin
      session = StripeService.new.create_checkout_session(payment_params[:order])
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      redirect_to root_path, alert: t('.payment_error', error: e.message)
    end
  end

  def success
    ActiveRecord::Base.transaction do
      @payment.success!
      @payment.order.completed!
    end
  rescue => e
    redirect_to root_path, alert: t('.error', error: e.message)
  end

  def cancel
    @payment.failed!
    redirect_to cart_order_path, alert: t('.failure')
  end

  private def set_payment
    @payment = Payment.find_by(id: params[:id])
    redirect_to root_path, alert: t('.not_exist') if @payment.nil?
  end

  private def payment_params
    params.require(:payment).permit(:order)
  end
end
