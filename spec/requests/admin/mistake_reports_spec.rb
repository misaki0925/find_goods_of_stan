require 'rails_helper'

RSpec.describe "Admin::MistakeReports", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/mistake_reports/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/admin/mistake_reports/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
