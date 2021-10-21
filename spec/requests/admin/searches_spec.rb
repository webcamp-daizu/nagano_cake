require 'rails_helper'

RSpec.describe "Admin::Searches", type: :request do
  describe "GET /search" do
    it "returns http success" do
      get "/admin/searches/search"
      expect(response).to have_http_status(:success)
    end
  end

end
