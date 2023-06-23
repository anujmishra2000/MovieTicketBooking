module StoreFront
  class MoviesController < StoreFront::BaseController
    before_action :set_movie, only: :show
    skip_before_action :authenticate_user!

    def index
      @q = Movie.includes(:poster_attachment).order(release_date: :desc).where(status: [:live, :upcoming]).ransack(params[:q])
      @movies = @q.result(distinct: true).paginate(page: params[:page], per_page: ENV['per_page'])
    end

    def show
      params[:from] ||= Time.current.strftime('%Y-%m-%d')
      params[:to] ||= 1.week.from_now.strftime('%Y-%m-%d')
      @movie_theatres = Theatre.includes(:shows).where('shows.movie_id': params[:id], 'shows.start_time': params[:from]..params[:to].to_date.end_of_day.to_s)
    end

    private def set_movie
      @movie = Movie.find_by(id: params[:id])
      return unless @movie.nil?
      redirect_to movies_path, alert: t('.not_exist')
    end
  end
end
