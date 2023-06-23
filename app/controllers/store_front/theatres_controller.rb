module StoreFront
  class TheatresController < StoreFront::BaseController
    before_action :set_theatre, only: :show
    skip_before_action :authenticate_user!

    def show
    end

    private def set_theatre
      @theatre = Theatre.find_by(id: params[:id])
      return unless @theatre.nil?
      redirect_to movies_path, alert: t('.not_exist')
    end
  end
end
