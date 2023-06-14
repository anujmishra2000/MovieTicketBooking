class StoreFront::TheatresController < StoreFront::BaseController
  before_action :set_theatre, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  private def set_theatre
    @theatre = Theatre.find_by(id: params[:id])
    redirect_to admin_theatres_path, alert: t('.not_exist') if @theatre.nil?
  end
end
