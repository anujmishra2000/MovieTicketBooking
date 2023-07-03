module Admin
  class OrdersController < Admin::BaseController
    before_action :set_order, only: [:show, :refund]

    def index
      @q = Order.includes(:user).sort_by_most_recent.ransack(params[:q])
      @orders = @q.result(distinct: true).paginate(page: params[:page], per_page: ENV['per_page'])
    end

    def show
    end

    def refund
      OrderRefundService.new(@order.id).create_refund(auto_cancelled: false, cancelled_by_user: current_user)
      redirect_to admin_order_path(@order)
    end

    private def set_order
      @order = Order.find_by(number: params[:id])
      redirect_to root_path, alert: t('.not_exist') if @order.nil?
    end
  end
end
