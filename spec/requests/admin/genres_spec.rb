require 'rails_helper'

RSpec.describe "Admin::Genres", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/genres/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/genres/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
