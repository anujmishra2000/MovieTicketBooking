class Admin::ShowsController < Admin::BaseController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :load_movies_and_theatres, only: [:edit, :new]

  def index
    @shows = Show.all.paginate(page: params[:page], per_page: ENV['per_page'])
  end

  def show
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      redirect_to admin_show_path(@show), notice: t('.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @show.update(show_params)
      redirect_to admin_show_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    if @show.destroy
      redirect_to admin_shows_path, notice: t('.success')
    else
      redirect_to admin_shows_path, alert: t('.failure')
    end
  end

  private def load_movies_and_theatres
    @live_movies = Movie.where(status: :live).pluck(:title, :id)
    @operational_theatres = Theatre.where(operational: true).pluck(:name, :id)
  end

  private def set_show
    @show = Show.find_by(id: params[:id])
    return unless @show.nil?
    redirect_to admin_shows_path, alert: t('.not_exist')
  end

  private def show_params
    params.require(:show).permit(:theatre_id, :movie_id, :start_time, :price, :status)
  end
end
