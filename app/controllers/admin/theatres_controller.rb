class Admin::TheatresController < Admin::BaseController
  before_action :set_theatre, only: [:show, :edit, :update, :destroy]

  def index
    @theatres = Theatre.all.paginate(page: params[:page], per_page: 2)
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
      redirect_to admin_theatre_path(@theatre), notice: t('.notice')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      redirect_to admin_theatre_path, notice: t('.notice')
    else
      render :edit
    end
  end

  def destroy
    @theatre.destroy
    redirect_to admin_theatres_path, notice: t('.notice')
  end

  private def set_theatre
    # debugger
    @theatre = Theatre.find(params[:id])
  end

  private def theatre_params
    params.require(:theatre).permit(:name, :screen_type, :seating_capacity, :operational, :contact_number, :contact_email, address_attributes: [:street, :state, :city, :pincode, :country_id])
  end
end
