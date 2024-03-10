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
          price: nil,
          seats_available: nil,
          status: 'active',
          movie_id: @movie.id,
          theatre_id: @theatre.id
        }
      }
  end

  def valid_params(start_time: 12.hours.from_now)
    {
      show: {
        start_time: start_time,
        price: FFaker::Number.decimal,
        seats_available: FFaker::Number.number,
        status: 'active',
        movie_id: @movie.id,
        theatre_id: @theatre.id
      }
    }
  end

  describe "GET #index" do
    before(:all) do
      sign_in @admin_user
      get admin_shows_path
    end

    it "should returns a successful response" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    context "with valid show id" do
      before(:all) do
        sign_in @admin_user
        get admin_show_path(@show)
      end

      it "should returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid show id" do
      before(:all) do
        sign_in @admin_user
        invalid_show = @show.id + 1
        get admin_show_path(invalid_show)
      end

      it "should redirects to show index with alert message" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:alert]).to eq('Show does not exist')
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
        @created_show = Show.last
      end

      it 'should set theatres capacity as seats available' do
        expect(@created_show.seats_available).to eq(@created_show.theatre.seating_capacity)
      end

      it 'should calculate and set end time' do
        expect(@created_show.end_time).to eq(@created_show.start_time + @created_show.movie.duration_in_mins.minutes)
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
        Timecop.freeze
        patch admin_show_path(@show), params: { show: { price: 200, created_at: Time.current } }
        @show.reload
      end

      after(:all) do
        Timecop.return
      end

      it "should updates the requested show" do
        expect(@show.price).to eq(200)
        expect(@show.created_at).to eq(Time.current.to_s.to_time)
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

    context "with overlapping show time" do
      before(:each) do
        sign_in @admin_user
        patch admin_show_path(@show), params: { show: { start_time: 12.hours.from_now } }
      end

      it 'should render edit template and display error messages' do
        expect(response).to render_template(:edit)

        expect(flash[:error]).to include("There is an overlapping show in the same theater.")
      end
    end

    context "with a past show" do
      before(:each) do
        sign_in @admin_user
        past_show = create(:show, movie: @movie, theatre: @theatre, start_time: 1.hour.ago)

        patch admin_show_path(past_show),
        params: { show: { price: 200 } }
      end

      it 'should render edit template and display error messages' do
        expect(response).to render_template(:edit)

        expect(flash[:error]).to include("Cannot edit past show")
      end
    end
  end

  describe "PATCH #cancel" do
    context 'with not a past show' do
      before(:all) do
        sign_in @admin_user
        patch cancel_admin_show_path(@show), params: { show: { status: 'cancelled' } }
        @show.reload
      end

      it "should cancels the requested show" do
        expect(@show.status).to eq('cancelled')
      end

      it "should redirects to the show's index page with success notice" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:notice]).to eq('Show was cancelled.')
      end
    end

    context 'with a past show' do
      before(:all) do
        sign_in @admin_user
        past_show = create(:show, movie: @movie, theatre: @theatre, start_time: 9.hour.ago)
        patch cancel_admin_show_path(past_show), params: { show: { status: 'cancelled' } }
      end

      it "should redirects to the show's index page with alert" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:alert]).to eq('Show was not cancelled.')
      end
    end
  end

  describe "PATCH #activate" do
    context 'with not a past show' do
      before(:all) do
        sign_in @admin_user
        patch activate_admin_show_path(@show), params: { show: { status: 'active' } }
        @show.reload
      end

      it "should activates the requested show" do
        expect(@show.status).to eq('active')
      end

      it "should redirects to the show with success notice" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:notice]).to eq('Show was activated.')
      end
    end

    context 'with a past show' do
      context 'with a past show' do
        before(:all) do
          sign_in @admin_user
          past_show = create(:show, movie: @movie, theatre: @theatre, start_time: 4.hour.ago)
          patch activate_admin_show_path(past_show), params: { show: { status: 'active' } }
        end

        it "should redirects to the show's index page with alert" do
          expect(response).to redirect_to(admin_shows_path)

          expect(flash[:alert]).to eq('Show was not activated.')
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "with invalid show id" do
      before(:all) do
        sign_in @admin_user
        invalid_show = @show.id + 100
        expect {
          delete admin_show_path(invalid_show)
        }.not_to change(Show, :count)
      end

      it "should redirects to the shows list with alert" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:alert]).to eq('Show does not exist')
      end
    end

    context "with line items" do
      before(:all) do
        sign_in @admin_user
        order = create(:order, user: @admin_user)
        line_item = create(:line_item, order: order, show: @show)
        expect {
          delete admin_show_path(@show)
        }.not_to change(Show, :count)
      end

      after(:all) do
        LineItem.delete_all
      end

      it "should redirects to the shows list with alert" do
        expect(response).to redirect_to(admin_shows_path)

        expect(flash[:alert]).to eq('Show was not destroyed.')
      end
    end

    context "with valid show id" do
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
end
