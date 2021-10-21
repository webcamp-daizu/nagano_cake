require 'rails_helper'

RSpec.describe "Public::CartItems", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/public/cart_items/index"
      expect(response).to have_http_status(:success)
    end
  end

end
