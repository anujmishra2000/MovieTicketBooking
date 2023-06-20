class OrdersController < ApplicationController
  before_action :set_order, only: :checkout

  def create
    @order = Order.find_by(user_id: current_user.id, status: 'in_progress') || Order.new(user_id: current_user.id, status: 'in_progress')
    @order.line_items.destroy_all if @order.line_items.any?
    @order.line_items.build(show_id: params[:show_id], quantity: params[:quantity])
    if @order.save
      redirect_to checkout_order_path(@order)
    else
      redirect_to request.referrer, alert: t('.failure')
    end
  end

  def checkout
  end

  private def set_order
    @order = Order.includes(line_items: {show: [ { movie: :poster_attachment }, :theatre] } ).find_by(user_id: current_user.id, status: 'in_progress')
    redirect_to request.referrer, alert: t('.not_exist') if @order.nil?
  end
end
