require 'rails_helper'

RSpec.describe Admin::TheatresController, type: :request do
  let!(:user) { create(:user, :admin) }
  let!(:country) { create(:country) }
  let!(:theatre) { create(:theatre) }
  let!(:address) { create(:address, country: country, theatre: theatre)}
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

  before { sign_in user }

  describe "GET #index" do
    it "returns a successful response" do
      get admin_theatres_path
      expect(response).to have_http_status(:success)
    end

    it "displays the correct theatres data" do
      theatres = create_list(:theatre, 3)
      get admin_theatres_path
      expect(assigns(:theatres).count).to be(4)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get admin_theatre_path(theatre)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get new_admin_theatre_path
      expect(response).to have_http_status(:success)
    end

    it "assigns a new theatre as @theatre" do
      get new_admin_theatre_path
      expect(assigns(:theatre)).to be_a_new(Theatre)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new theatre" do
        expect {
          post admin_theatres_path, params: valid_params
        }.to change(Theatre, :count).by(1)
        expect(flash[:notice]).to eq('Theatre was successfully created')
      end

      it "redirects to the created theatre" do
        post admin_theatres_path, params: valid_params
        expect(response).to redirect_to(admin_theatre_path(Theatre.last))
        expect(flash[:notice]).to eq('Theatre was successfully created')
      end
    end

    context "with invalid params" do
      it "does not create a new theatre" do
        expect {
          post admin_theatres_path, params: { theatre: { name: '' } }
        }.not_to change(Theatre, :count)
      end

      it "renders the 'new' template" do
        post admin_theatres_path, params: { theatre: { name: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get edit_admin_theatre_path(theatre)
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

      it "updates the requested theatre" do
        patch admin_theatre_path(theatre), params: { theatre: new_attributes }
        theatre.reload
        expect(theatre.name).to eq('Updated Theatre')
        expect(theatre.seating_capacity).to eq(300)
        expect(flash[:notice]).to eq('Theatre was successfully updated.')
      end

      it "redirects to the theatre" do
        patch admin_theatre_path(theatre), params: { theatre: new_attributes }
        expect(response).to redirect_to(admin_theatre_path(theatre))
        expect(flash[:notice]).to eq('Theatre was successfully updated.')
      end
    end

    context "with invalid params" do
      it "renders the 'edit' template" do
        patch admin_theatre_path(theatre), params: { theatre: { name: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested theatre" do
      theatre_to_delete = create(:theatre)
      expect {
        delete admin_theatre_path(theatre_to_delete)
      }.to change(Theatre, :count).by(-1)
      expect(flash[:notice]).to eq('Theatre was successfully destroyed.')
    end

    it "redirects to the theatres list" do
      delete admin_theatre_path(theatre)
      expect(response).to redirect_to(admin_theatres_path)
      expect(flash[:notice]).to eq('Theatre was successfully destroyed.')
    end
  end
end
