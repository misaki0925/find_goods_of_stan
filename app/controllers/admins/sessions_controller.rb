class Admins::SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new;end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to admins_articles_path, notice: "ログインしました"
    else
      flash.now[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to root_path, success: "ログアウトしました"
  end
end
