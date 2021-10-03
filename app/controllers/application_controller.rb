class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    redirect_to admins_login_path, danger: t('flash.before_login')
  end
end
