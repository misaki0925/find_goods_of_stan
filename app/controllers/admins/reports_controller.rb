class Admins::ReportsController < ApplicationController
  def index
    @reports = Report.all.order(created_at: :desc).page(params[:page]).per(8)
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy
    redirect_to admins_reports_path, notice: t('flash.deleted')
  end
end
