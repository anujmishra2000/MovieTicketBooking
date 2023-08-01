require 'rails_helper'

RSpec.describe Admin::MoviesController, type: :request do

  before(:all) do
    @admin_user = create(:user, :admin)
    @movie = create(:movie)
    @invalid_params =
      {
        movie: {
          title: '',
          release_date: '',
          description: '',
          duration_in_mins: nil,
          status: 'live',
          poster: nil
        }
      }
  end

  def valid_params(title: 'Avengers', poster_path: "#{Rails.root}/spec/support/images/infinity.jpg")
    poster_file = File.open(poster_path)
    {
      movie: {
        title: title,
        release_date: '2023-07-27',
        description: 'Avengers Infinity War is a 2018 American superhero film based on the Marvel Comics superhero team the Avengers. Produced by Marvel Studios and distributed by Walt Disney Studios Motion Pictures  it is the sequel to The Avengers 2012 and Avengers Age of Ultron 2015 and the 19th film in the Marvel Cinematic Universe',
        duration_in_mins: 170,
        status: 'live',
        poster: Rack::Test::UploadedFile.new(poster_file, 'image/jpeg')
      }
    }
  end

  after(:all) do
    User.delete_all
    Movie.delete_all
  end

  describe "GET #index" do
    before(:all) do
      sign_in @admin_user
      get admin_movies_path
    end

    it "should returns a successful response" do
      expect(response).to have_http_status(:success)
    end

    it "should display the correct movies data" do
      movies = create_list(:movie, 3)
      expect(assigns(:movies).count).to be(4)
    end
  end

  describe "GET #show" do
    context "with valid movie id" do
      before(:all) { sign_in @admin_user }

      it "should returns a successful response" do
        get admin_movie_path(@movie)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid movie id" do
      before(:all) { sign_in @admin_user }

      it "should redirects to movie index with alert message" do
        invalid_movie = @movie.id + 1
        get admin_movie_path(invalid_movie)
        expect(response).to redirect_to(admin_movies_path)
        expect(flash[:alert]).to eq('Movie does not exit')
      end
    end
  end

  describe "GET #new" do
    before(:all) do
      sign_in @admin_user
      get new_admin_movie_path
    end

    it "should returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should assigns a new movie as movie" do
      expect(assigns(:movie)).to be_a_new(Movie)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:all) do
        sign_in @admin_user
        expect {
          post admin_movies_path, params: valid_params
        }.to change(Movie, :count).by(1)
      end

      it "should redirects to the created movie with success notice" do
        expect(response).to redirect_to(admin_movie_path(Movie.last))
        expect(flash[:notice]).to eq('Movie was successfully created')
      end
    end

    context "with invalid params" do
      before(:each) do
        sign_in @admin_user
        expect {
          post admin_movies_path, params: @invalid_params
        }.not_to change(Movie, :count)
      end

      it 'should render new template and display error messages' do
        expect(response).to render_template(:new)

        expect(flash[:error]).to include("Title can't be blank")
        expect(flash[:error]).to include("Release date can't be blank")
        expect(flash[:error]).to include("Description can't be blank")
        expect(flash[:error]).to include("Duration in mins can't be blank")
        expect(flash[:error]).to include("Poster can't be blank")
      end
    end
  end

  describe "GET #edit" do
    before(:all) do
      sign_in @admin_user
      get edit_admin_movie_path(@movie)
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
            title: 'Updated Movie',
            duration_in_mins: 175
          }
        patch admin_movie_path(@movie), params: { movie: @new_attributes }
      end

      it "should updates the requested movie" do
        @movie.reload
        expect(@movie.title).to eq('Updated Movie')
        expect(@movie.duration_in_mins).to eq(175)
        expect(flash[:notice]).to eq('Movie was successfully updated.')
      end

      it "should redirects to the movie" do
        expect(response).to redirect_to(admin_movie_path(@movie))
        expect(flash[:notice]).to eq('Movie was successfully updated.')
      end
    end

    context "with invalid params" do
      before(:each) do
        sign_in @admin_user
        patch admin_movie_path(@movie), params: @invalid_params
      end

      it 'should render edit template and display error messages' do
        expect(response).to render_template(:edit)

        expect(flash[:error]).to include("Title can't be blank")
        expect(flash[:error]).to include("Release date can't be blank")
        expect(flash[:error]).to include("Description can't be blank")
        expect(flash[:error]).to include("Duration in mins can't be blank")
        expect(flash[:error]).to include("Poster can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:all) do
      sign_in @admin_user
      expect {
        delete admin_movie_path(@movie)
      }.to change(Movie, :count).by(-1)
    end

    it "should redirects to the movies list with success notice" do
      expect(response).to redirect_to(admin_movies_path)
      expect(flash[:notice]).to eq('Movie was successfully destroyed.')
    end
  end
end
