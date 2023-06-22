class OrdersController < ApplicationController
  before_action :set_order, only: :cart
  before_action :set_or_create_order, only: :create

  def create
    @order.line_items.destroy_all
    @order.line_items.build(show_id: params[:show_id], quantity: params[:quantity])
    if @order.save
      redirect_to cart_order_path(@order)
    else
      redirect_to request.referrer, alert: @order.errors.to_a
    end
  end

  def cart
  end

  private def set_or_create_order
    @order = current_user.orders.in_progress.find_or_create_by({})
  end

  private def set_order
    @order = current_user.orders.includes(line_items: { show: [ { movie: :poster_attachment }, :theatre] } ).in_progress.first
    redirect_to request.referrer, alert: t('.not_exist') if @order.nil?
  end
end
