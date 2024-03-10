require 'rails_helper'

RSpec.describe "Orders", type: :request do

  let!(:user) { create(:user) }
  let!(:order) { create(:order, user: user, status: 'completed') }
  before { sign_in user }
  let!(:movie) { create(:movie) }
  let!(:theatre) { create(:theatre) }
  let!(:show) { create(:show, movie: movie, theatre: theatre) }
  let!(:line_item) { create(:line_item, order: order, show: show) }

  describe "GET #index" do
    it "returns a successful response" do
      get orders_path
      expect(response).to be_successful
    end

    let!(:orders) { create_list(:order,1, user: user, status: 'completed') }
    it "displays the correct order data" do
      get orders_path
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get order_path(order)
      expect(response).to be_successful
    end

    it "displays the correct order data" do
      get order_path(order)
      expect(assigns :order).to eq order
    end
  end

  describe "POST #create" do
    let!(:movie) { create(:movie) }
    let!(:theatre) { create(:theatre) }
    let!(:show) { create(:show, movie: movie, theatre: theatre) }

    context "order already exists" do
      let!(:existing_order) { create(:order, user: user) }
      let!(:existing_line_item) { create(:line_item, order: existing_order, show: show) }

      it 'should delete existing line items' do
        post orders_path(show_id: show.id, quantity: 2)
        expect(LineItem.find_by(id: existing_line_item.id)).to be_nil
      end
    end

    context "order does not exists" do
      it 'should create new order' do
        post orders_path(show_id: show.id, quantity: 2)
        expect(user.orders.in_progress.size).to be(1)
      end
    end

    it 'should create new line item' do
      post orders_path(show_id: show.id, quantity: 2)
      expect(order.line_items.size).to be(1)
    end

    it 'should redirect to cart_order_path' do
      post orders_path(show_id: show.id, quantity: 2)
      expect(response).to have_http_status(302)
    end
  end

  describe "GET #cart" do
    let!(:in_progress_order) { create(:order, user: user) }
    it "returns a successful response" do
      get cart_order_path(in_progress_order)
      expect(response).to be_successful
    end

    it "displays the correct order data" do
      get cart_order_path(in_progress_order)
      expect(assigns :order).to eq in_progress_order
    end
  end

  describe "POST #refund" do
    it "should process a refund" do
      post refund_order_path(order, number: order.number)
      expect(order.status).to eq('cancelled')
    end
  end
end
