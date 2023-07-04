class CancelUnderoccupiedShowsJob < ApplicationJob
  def perform
    show_ids = Show.next_hour.low_occupancy.ids
    order_ids = Order.completed.joins(:line_items).where(line_items: { show_id: show_ids }).ids
    order_ids.each do |order_id|
      OrderRefundService.new(order_id).create_refund(auto_cancelled: true)
    end
  end
end
