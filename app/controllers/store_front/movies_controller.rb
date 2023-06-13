class StoreFront::MoviesController < StoreFront::BaseController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!

  def index
    @q = Movie.order(release_date: :desc).where('status IN (0, 1)').ransack(params[:q])
    @movies = @q.result(distinct: true).paginate(page: params[:page], per_page: ENV['per_page'])
  end

  def show
  end

  private def set_movie
    @movie = Movie.find_by(id: params[:id])
    redirect_to admin_movies_path, alert: t('.not_exist') if @movie.nil?
  end
end
