class ReportsController < ApplicationController
  skip_before_action :require_login

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
    redirect_to articles_path, notice: t('flash.make_report')
    else
      flash.now[:danger] = t('flash.not_make_report')
      render :new
    end
  end

  private

    def report_params
      params.require(:report).permit(:comment)
    end

end
