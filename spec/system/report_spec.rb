require 'rails_helper'
RSpec.describe 'Report', type: :system do
  describe "ユーザー" do
    describe "報告コメント作成" do
      before do
        visit articles_path
        find(".navbar-toggler").click
        click_on 'REPORT'
      end
      # it '報告コメント作成に成功する' do
      #   find("#report_comment").set("test_test")
      #   expect{
      #     click_button '送信'
      #     sleep 0.5
      #   }.to change { Report.count }.by(+1)
      #   expect(current_path).to eq(articles_path)
      #   expect(page).to have_content('ありがとうございます。コメントが送信されました。') 
      # end ok

      # it '報告コメント作成に失敗する' do
      #   find("#report_comment").set(nil)
      #   expect{
      #     click_button '送信'
      #     sleep 0.5
      #   }.not_to change { Report.count }
      #   expect(page).to have_content('コメントを入力してから送信してください。')
      #   expect(current_path).to eq(reports_path)
      # end ok
    end
  end
end