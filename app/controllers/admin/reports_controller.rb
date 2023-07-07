module Admin
  class ReportsController < Admin::BaseController

    def index
    end

    def users_spendings
      params[:from] ||= 10.days.ago.strftime('%Y-%m-%d')
      params[:to] ||= Time.current.strftime('%Y-%m-%d')
      time_range = params[:from]..params[:to].to_date.end_of_day.to_s
      select_statement = 'name, email, sum(COALESCE(orders.total, 0)) as total_paid, sum(COALESCE(refunds.amount, 0)) as total_refund'
      @users = User.left_joins(orders: { payments: :refunds })
                    .group(:id).select(select_statement).order('total_paid DESC', :email)
                    .where(orders: { completed_at: time_range } )
    end

    def theatres_revenue
      params[:from] ||= 10.days.ago.strftime('%Y-%m-%d')
      params[:to] ||= Time.current.strftime('%Y-%m-%d')
      time_range = params[:from]..params[:to].to_date.end_of_day.to_s
      select_statement = 'name, sum(COALESCE(orders.total, 0)) as total_revenue, sum(COALESCE(refunds.amount, 0)) as total_refund'
      @theatres = Theatre.left_joins(shows: { line_items: { order: { payments: :refunds } } }).group(:id)
                          .select(select_statement).order('total_revenue DESC', :name)
                          .where(shows: { line_items: { orders: { completed_at: time_range } } })
    end
  end
end
