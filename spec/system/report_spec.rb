require 'rails_helper'

RSpec.describe 'Report', type: :system do
  describe "ユーザー" do
    describe "報告コメント作成" do
      xit '報告コメント作成に成功する' do
        visit root_path
        click_on '間違いにお気づきの方はこちらから'
        visit new_report_path
        fill_in 'Report',	with: "test_text"
        expect{
          click_button '送信'
          sleep 0.5
        }.to change { Report.count }.by(+1)
        expect(current_path).to eq(articles_path)
        expect(page).to have_content('ありがとうございます。送信されました。') 
      end

      xit '報告コメント作成に失敗する' do
        visit root_path
        click_on '間違いにお気づきの方はこちらから'
        visit new_report_path
        fill_in 'Report',	with: " "
        expect{
          click_button '送信'
          sleep 0.5
        }.not_to change { Report.count }
        expect(page).to have_content('コメントを入力してください。')
        expect(current_path).to eq(reports_path)
      end
    end
  end
end