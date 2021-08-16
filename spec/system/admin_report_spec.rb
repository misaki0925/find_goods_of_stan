require 'rails_helper'

RSpec.describe 'AdiminsReport', type: :system  do
  describe '管理者ユーザー' do
    let!(:report) { create(:report) }
    let(:user) { create(:user, :admin) }
    before { login(user) }
    describe "報告コメント削除" do
      xit '報告コメント削除に成功する' do
        visit admins_reports_path
        expect(page).to have_content('test_text')
        expect{
          click_on '削除'
          sleep 0.5
        }.to change { Report.count }.by(-1)
        expect(page).to have_content('報告が削除されました。')
        expect(current_path).to eq(admins_reports_path)
        expect(page).to have_no_content('test_text')
      end
    end
  end
end