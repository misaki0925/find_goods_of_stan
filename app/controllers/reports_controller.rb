class ReportsController < ApplicationController
  skip_before_action :require_login
  def new
    @report = Report.new
  end

  def create
    Report.create(report_params)
    redirect_to articles_path
  end

  private

  def report_params
    params.require(:report).permit(:comment)
  end
end
