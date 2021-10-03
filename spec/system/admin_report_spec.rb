require 'rails_helper'
RSpec.describe 'AdiminsReport', type: :system  do
  describe '管理者ユーザー' do
    let!(:report) { create(:report) }
    let(:user) { create(:user, :admin) }
    before { login(user) }
    describe "報告コメント削除" do
      it '報告コメント削除に成功する' do
        visit admins_reports_path
        expect(page).to have_content('test_text')
        expect{
              page.accept_confirm I18n.t('defaults.confirm_delete') do
              click_on I18n.t('defaults.delete')
            end
            sleep 0.5
          }.to change{Report.count}.by(-1)
        expect(page).to have_content I18n.t('flash.deleted')
        expect(current_path).to eq(admins_reports_path)
        expect(page).to have_no_content('test_text')
      end
    end
  end
end