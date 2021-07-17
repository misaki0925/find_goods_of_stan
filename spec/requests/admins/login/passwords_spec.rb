require 'rails_helper'

RSpec.describe "Admins::Login::Passwords", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/admins/login/passwords/show"
      expect(response).to have_http_status(:success)
    end
  end

end
