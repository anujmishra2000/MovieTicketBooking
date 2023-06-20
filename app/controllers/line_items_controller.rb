class LineItemsController < ApplicationController
  before_action :set_line_item

  def destroy
    if @line_item.destroy
      redirect_to movies_path, notice: t('.success')
    else
      redirect_to movies_path, alert: t('.failure')
    end
  end

  private def set_line_item
    @line_item = LineItem.find_by(id: params[:id])
    redirect_to request.referrer, alert: t('.not_exist') if @line_item.nil?
  end
end
