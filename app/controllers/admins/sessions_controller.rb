class Admins::SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create new]

  def new;end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to admins_articles_path, success: t('flash.login')
    else
      flash.now[:danger] = t('flash.not_login')
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to admins_login_path, success: t('flash.logout')
  end
end
