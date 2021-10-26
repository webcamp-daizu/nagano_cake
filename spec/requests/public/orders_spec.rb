require 'rails_helper'

RSpec.describe "Public::Orders", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/public/orders/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/orders/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/public/orders/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /thankyou" do
    it "returns http success" do
      get "/public/orders/thankyou"
      expect(response).to have_http_status(:success)
    end
  end

end
