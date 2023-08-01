class Admin::MoviesController < Admin::BaseController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.all.paginate(page: params[:page], per_page: ENV['per_page'])
  end

  def show
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to admin_movie_path(@movie), notice: t('.success')
    else
      flash.now[:error] = @movie.errors.to_a
      render :new
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to admin_movie_path, notice: t('.success')
    else
      flash.now[:error] = @movie.errors.to_a
      render :edit
    end
  end

  def destroy
    if @movie.destroy
      redirect_to admin_movies_path, notice: t('.success')
    else
      redirect_to admin_movies_path, alert: t('.failure')
    end
  end

  private def set_movie
    @movie = Movie.find_by(id: params[:id])
    redirect_to admin_movies_path, alert: t('.not_exist') if @movie.nil?
  end

  private def movie_params
    params.require(:movie).permit(:title, :release_date, :description, :duration_in_mins, :status, :poster)
  end
end
