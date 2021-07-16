class Admins::ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  # def destroy #後での方がいいかもadmin権限をつける
  #   report = Report.find(params[:id])
  #   byebug
  # end


end
