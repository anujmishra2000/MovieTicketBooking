class Admin::TheatresController < Admin::BaseController
  before_action :set_theatre, only: [:show, :edit, :update, :destroy]
  before_action :load_countries, only: [:edit, :new]

  def index
    @theatres = Theatre.all.paginate(page: params[:page], per_page: ENV['per_page'])
  end

  def show
  end

  def new
    @theatre = Theatre.new
    @theatre.build_address
  end

  def create
    @theatre = Theatre.new(theatre_params)
    if @theatre.save
      redirect_to admin_theatre_path(@theatre), notice: t('.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      redirect_to admin_theatre_path, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    if @theatre.destroy
      redirect_to admin_theatres_path, notice: t('.success')
    else
      redirect_to admin_theatres_path, alert: t('.failure')
    end
  end

  private def load_countries
    @countries = Country.pluck(:name, :id)
  end

  private def set_theatre
    @theatre = Theatre.find_by(id: params[:id])
    redirect_to admin_theatres_path, alert: t('.not_exist') if @theatre.nil?
  end

  private def theatre_params
    params.require(:theatre).permit(:name, :screen_type, :seating_capacity, :operational, :contact_number, :contact_email, address_attributes: [:street, :state, :city, :pincode, :country_id])
  end
end
