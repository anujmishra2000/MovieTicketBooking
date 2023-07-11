module Api
  class OrdersController < Api::BaseController
    before_action :authorize_api_user

    def index
      @orders = Order.eager_load(line_items: {show: :movie}).where( completed_at: params[:from]..params[:to].to_date.end_of_day.to_s)
      render json: @orders, each_serializer: OrderSerializer
    end
  end
end
