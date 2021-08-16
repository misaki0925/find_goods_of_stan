class ReportsController < ApplicationController
  skip_before_action :require_login
  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
    redirect_to articles_path, notice: "ありがとうございます。送信されました。"
    else
      flash.now[:notice] = "コメントを入力してください。"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:comment)
  end

end
