require 'rails_helper'

RSpec.describe "Admins::Reports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admins/reports/index"
      expect(response).to have_http_status(:success)
    end
  end

end
