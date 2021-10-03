require 'rails_helper'
RSpec.describe 'Report', type: :system do
  describe "ユーザー" do
    describe "報告コメント作成" do
      before do
        visit articles_path
        find(".navbar-toggler").click
        click_on I18n.t('layouts.header.report')
      end
      it '報告コメント作成に成功する' do
        find("#report_comment").set("test_test")
        expect{
          click_button I18n.t('reports.new.submit')
          sleep 0.5
        }.to change { Report.count }.by(+1)
        expect(current_path).to eq(articles_path)
        expect(page).to have_content I18n.t('flash.make_report')
      end

      it '報告コメント作成に失敗する' do
        find("#report_comment").set(nil)
        expect{
          click_button I18n.t('reports.new.submit')
          sleep 0.5
        }.not_to change { Report.count }
        expect(page).to have_content I18n.t('flash.not_make_report')
        expect(current_path).to eq(reports_path)
      end
    end
  end
end