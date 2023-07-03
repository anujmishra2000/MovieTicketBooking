class CancelUnderoccupiedShowsJob < ApplicationJob
  def perform
    @orders = Order.completed.joins(line_items: { show: :theatre }).where("shows.start_time <= ? AND shows.end_time >= ? AND shows.seats_available  > (0.8 * theatres.seating_capacity)", Time.current + 1.hour, Time.current)
    @orders.each do |order|
      payment = order.payments.success.last
      OrderRefundService.new(payment).create_refund(auto_cancelled: true)
    end
  end
end
