require 'rails_helper'

RSpec.describe Admin::TheatresController, type: :request do
  let(:valid_params) do
    {
      theatre: {
        name: 'New Theatre',
        screen_type: 'imax',
        seating_capacity: 200,
        operational: true,
        contact_number: '1234567890',
        contact_email: 'test@example.com',
        address_attributes: {
          street: 'Test Street',
          state: 'Test State',
          city: 'Test City',
          pincode: '123456',
          country_id: create(:country).id
        }
      }
    }
  end

  let(:invalid_params) do
    {
      theatre: {
        name: '',
        screen_type: '',
        seating_capacity: nil,
        operational: true,
        contact_number: '',
        contact_email: '',
      }
    }
  end

  before(:all) do
    @admin_user = create(:user, :admin)
    @country = create(:country)
    @theatre = create(:theatre)
    @address = create(:address, country: @country, theatre: @theatre)
  end

  before(:each) do
    sign_in @admin_user
  end

  after(:all) do
    @admin_user.destroy
    @address.destroy
    @country.destroy
    @theatre.destroy
  end

  describe "GET #index" do
    before(:each) { get admin_theatres_path }

    it "should returns a successful response" do
      expect(response).to have_http_status(:success)
    end

    it "should display the correct theatres data" do
      theatres = create_list(:theatre, 3)
      expect(assigns(:theatres).count).to be(4)
    end
  end

  describe "GET #show" do
    context "with valid theatre id" do
      it "should returns a successful response" do
        get admin_theatre_path(@theatre)
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid theatre id" do
      it "should redirects to theatre index with alert message" do
        invalid_theatre = @theatre.id + 1
        get admin_theatre_path(invalid_theatre)
        expect(response).to redirect_to(admin_theatres_path)
        expect(flash[:alert]).to eq('Theatre does not exit')
      end
    end
  end

  describe "GET #new" do
    before(:each) { get new_admin_theatre_path }

    it "should returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "should assigns a new theatre as theatre" do
      expect(assigns(:theatre)).to be_a_new(Theatre)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      before(:each) do
        expect {
          post admin_theatres_path, params: valid_params
        }.to change(Theatre, :count).by(1)
      end

      it "should redirects to the created theatre with success notice" do
        expect(response).to redirect_to(admin_theatre_path(Theatre.last))
        expect(flash[:notice]).to eq('Theatre was successfully created')
      end
    end

    context "with invalid params" do
      before(:each) do
        expect {
          post admin_theatres_path, params: invalid_params
        }.not_to change(Theatre, :count)
      end

      it "should render the 'new' template" do
        expect(response).to render_template(:new)
      end

      it 'should display error messages' do
        expect(flash[:error]).to include("Name can't be blank")
        expect(flash[:error]).to include("Screen type can't be blank")
        expect(flash[:error]).to include("Seating capacity can't be blank")
        expect(flash[:error]).to include("Contact number can't be blank")
        expect(flash[:error]).to include("Contact email can't be blank")
      end
    end
  end

  describe "GET #edit" do
    before(:each) { get edit_admin_theatre_path(@theatre) }

    it "should returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) do
        {
          name: 'Updated Theatre',
          seating_capacity: 300
        }
      end

      before(:each) { patch admin_theatre_path(@theatre), params: { theatre: new_attributes } }

      it "should updates the requested theatre" do
        @theatre.reload
        expect(@theatre.name).to eq('Updated Theatre')
        expect(@theatre.seating_capacity).to eq(300)
        expect(flash[:notice]).to eq('Theatre was successfully updated.')
      end

      it "should redirects to the theatre" do
        expect(response).to redirect_to(admin_theatre_path(@theatre))
        expect(flash[:notice]).to eq('Theatre was successfully updated.')
      end
    end

    context "with invalid params" do

      before(:each) { patch admin_theatre_path(@theatre), params: invalid_params }

      it "should renders the 'edit' template" do
        expect(response).to render_template(:edit)
      end

      it 'should display error messages' do
        expect(flash[:error]).to include("Name can't be blank")
        expect(flash[:error]).to include("Screen type can't be blank")
        expect(flash[:error]).to include("Seating capacity can't be blank")
        expect(flash[:error]).to include("Contact number can't be blank")
        expect(flash[:error]).to include("Contact email can't be blank")
      end
    end

    context "with invalid params and over seating capacity" do
      before(:each) do
        invalid_params[:theatre][:seating_capacity] = 505
        patch admin_theatre_path(@theatre), params: invalid_params
      end

      it "should render the 'edit' template" do
        expect(response).to render_template(:edit)
      end

      it 'should display error messages' do
        expect(flash[:error]).to include("Name can't be blank")
        expect(flash[:error]).to include("Screen type can't be blank")
        expect(flash[:error]).to include("Seating capacity must be less than 500")
        expect(flash[:error]).to include("Contact number can't be blank")
        expect(flash[:error]).to include("Contact email can't be blank")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      expect {
        delete admin_theatre_path(@theatre)
      }.to change(Theatre, :count).by(-1)
    end

    it "should redirects to the theatres list with success notice" do
      expect(response).to redirect_to(admin_theatres_path)
      expect(flash[:notice]).to eq('Theatre was successfully destroyed.')
    end
  end
end
