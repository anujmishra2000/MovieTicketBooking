class Admin::TheatresController < Admin::BaseController
  before_action :set_theatre, only: [:show, :edit, :update, :destroy]

  def index
    @theatres = Theatre.all
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
      redirect_to admin_theatre_path(@theatre), notice: 'Product was successfully created'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      redirect_to admin_theatre_path, notice: 'Theatre was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # debugger
    @theatre.destroy
    redirect_to admin_theatres_path, notice: 'Product was successfully destroyed.'
  end

  private def set_theatre
    # debugger
    @theatre = Theatre.find(params[:id])
  end

  private def theatre_params
    params.require(:theatre).permit(:name, :screen_type, :seating_capacity, :operational, :contact_number, :contact_email, address_attributes: [:street, :state, :country_id, :city, :pincode])
  end
end
