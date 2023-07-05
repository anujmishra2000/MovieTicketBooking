module Api
  class OrdersController < Api::BaseController
    before_action :current_api_user

    def index
      params[:from] ||= 1.week.ago.strftime('%Y-%m-%d')
      params[:to] ||= Time.current.strftime('%Y-%m-%d')
      @orders = Order.where( completed_at: params[:from]..params[:to].to_date.end_of_day.to_s)
      render json: @orders, each_serializer: OrderSerializer
    end
  end
end
