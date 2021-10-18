require 'rails_helper'

RSpec.describe "Public::Items", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/public/items/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/public/items/show"
      expect(response).to have_http_status(:success)
    end
  end

end
