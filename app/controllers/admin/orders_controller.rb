module Admin
  class OrdersController < Admin::BaseController
    before_action :set_order, only: :show

    def index
      @q = Order.includes(:user).sort_by_most_recent.ransack(params[:q])
      @orders = @q.result(distinct: true).paginate(page: params[:page], per_page: ENV['per_page'])
    end

    def show
    end

    def refund
      payment = Payment.find_by(id: params[:id])
      stripe_refund = StripeService.create_refund(payment)
      ActiveRecord::Base.transaction do
        payment.refunds.credited.create(stripe_refund_id: stripe_refund.id, amount: stripe_refund.amount / 100, completed_at: Time.current)
        payment.order.cancelled!
        payment.order.update(cancelled_at: Time.current, auto_cancellation: false, cancelled_by_user_id: current_user.id)
      end
      OrderMailer.with(order: @order, refund_id: refund.id).cancelled.deliver_later
      redirect_to admin_order_path(payment.order)
    end

    private def set_order
      @order = Order.find_by(number: params[:id])
      redirect_to root_path, alert: t('.not_exist') if @order.nil?
    end
  end
end
