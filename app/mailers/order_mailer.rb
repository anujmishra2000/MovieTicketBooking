class OrderMailer < ApplicationMailer
  before_action :set_order

  def confirmed
    @order.line_items.each do |line_item|
      attachments.inline["#{line_item.id}.jpg"] = line_item.show.movie.poster.download
    end

    mail to: @order.user.email, subject: 'Movie Ticket Booking Confirmation'
  end

  private def set_order
    @order = params[:order]
  end
end
