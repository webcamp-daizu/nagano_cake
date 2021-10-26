require 'rails_helper'

RSpec.describe "Admin::Items", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/items/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/items/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/items/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/items/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
