require 'rails_helper'

RSpec.describe "Admins::Articles", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/admins/articles/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/admins/articles/index"
      expect(response).to have_http_status(:success)
    end
  end

end
