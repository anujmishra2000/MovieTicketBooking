require 'rails_helper'

RSpec.describe Admin::ShowsController, type: :request do

  before(:all) do
    @admin_user = create(:user, :admin)
    @movie = create(:movie)
    @theatre = create(:theatre)
    @show = create(:show, movie: @movie, theatre: @theatre)
    @invalid_params =
      {
        show: {
          start_time: nil,
          end_time: nil,
          price: nil,
          seats_available: nil,
          status: 'active',
          movie_id: @movie.id,
          theatre_id: @theatre.id
        }
      }
  end

  def valid_params
    {
      show: {
        start_time: 12.hours.from_now,
        end_time: 13.hours.from_now,
        price: 100,
        seats_available: 50,
        status: 'active',
        movie_id: @movie.id,
        theatre_id: @theatre.id
      }
    }
  end

  after(:all) do
    User.delete_all
    Show.delete_all
    Movie.delete_all
    Theatre.delete_all
  end

  describe "GET #index" do
    before(:all) do
      sign_in @admin_user
      get admin_shows_path
    end

    it "should returns a successful response" do
      expect(response).to have_http_status(:success)
    end

    it "should display the correct shows data" do
      shows = create_list(:show, 3)
      expect(assigns(:shows).count).to be(4)
    end
  end

  describe "GET #show" do
    context "with valid show id" do
      before(:all) { sign_in @admin_user }

      it "should returns a successful response" do
        get admin_show_path(@show)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid show id" do
      before(:all) { sign_in @admin_user }

      it "should redirects to show index with alert message" do
        invalid_show = @show.id + 1
        get admin_show_path(invalid_show)
        expect(response).to redirect_to(admin_shows_path)
        expect(flash[:alert]).to eq('Show does not exit')
      end
    end
  end

  describe "GET #new" do
    before(:all) do
      sign_in @admin_user
      get new_admin_show_path
    end

    it "should returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should assigns a new show as show" do
      expect(assigns(:show)).to be_a_new(Show)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:all) do
        sign_in @admin_user
        expect {
          post admin_shows_path, params: valid_params
        }.to change(Show, :count).by(1)
      end

      it "should redirects to the created show with success notice" do
        expect(response).to redirect_to(admin_show_path(Show.last))
        expect(flash[:notice]).to eq('Show was successfully created')
      end
    end

    context "with invalid params" do
      before(:each) do
        sign_in @admin_user
        expect {
          post admin_shows_path, params: @invalid_params
        }.not_to change(Show, :count)
      end

      it 'should render new template and display error messages' do
        expect(response).to render_template(:new)

        expect(flash[:error]).to include("Start time can't be blank")
        expect(flash[:error]).to include("Price can't be blank")
      end
    end
  end

  describe "GET #edit" do
    before(:all) do
      sign_in @admin_user
      get edit_admin_show_path(@show)
    end

    it "should returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      before(:all) do
        sign_in @admin_user
        @new_attributes =
          {
            price: 200
          }
        patch admin_show_path(@show), params: { show: @new_attributes }
      end

      it "should updates the requested show" do
        @show.reload
        expect(@show.price).to eq(200)
      end

      it "should redirects to the show with success notice" do
        expect(response).to redirect_to(admin_show_path(@show))
        expect(flash[:notice]).to eq('Show was successfully updated.')
      end
    end

    context "with invalid params" do
      before(:each) do
        sign_in @admin_user
        patch admin_show_path(@show), params: @invalid_params
      end

      it 'should render edit template and display error messages' do
        expect(response).to render_template(:edit)

        expect(flash[:error]).to include("Start time can't be blank")
        expect(flash[:error]).to include("Price can't be blank")
      end
    end
  end

  describe "PATCH #cancel" do
    before(:all) do
      sign_in @admin_user
      new_attributes =
        {
          status: 'cancelled'
        }
      patch admin_show_path(@show), params: { show: new_attributes }
    end

    it "should cancels the requested show" do
      @show.reload
      expect(@show.status).to eq('cancelled')
    end

    it "should redirects to the show with success notice" do
      expect(response).to redirect_to(admin_show_path(@show))
      expect(flash[:notice]).to eq('Show was successfully updated.')
    end
  end

  describe "PATCH #activate" do
    before(:all) do
      sign_in @admin_user
      new_attributes =
        {
          status: 'active'
        }
      patch admin_show_path(@show), params: { show: new_attributes }
    end

    it "should activates the requested show" do
      @show.reload
      expect(@show.status).to eq('active')
    end

    it "should redirects to the show with success notice" do
      expect(response).to redirect_to(admin_show_path(@show))
      expect(flash[:notice]).to eq('Show was successfully updated.')
    end
  end

  describe "DELETE #destroy" do
    before(:all) do
      sign_in @admin_user
      expect {
        delete admin_show_path(@show)
      }.to change(Show, :count).by(-1)
    end

    it "should redirects to the shows list with success notice" do
      expect(response).to redirect_to(admin_shows_path)
      expect(flash[:notice]).to eq('Show was successfully destroyed.')
    end
  end
end
