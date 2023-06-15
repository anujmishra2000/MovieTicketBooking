module StoreFront
  class ShowsController < StoreFront::BaseController
    before_action :set_show, only: :show
    skip_before_action :authenticate_user!

    def show
    end

    private def set_show
      @show = Show.find_by(movie_id: params[:movie_id], theatre_id: params[:theatre_id])
      return unless @show.nil?
      redirect_to movies_path, alert: t(:not_exist)
    end
  end
end
