class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :require_login

  def set_item_search
    @q = Article.ransack(params[:q])
    @set_items = @q.result
  end

  private

  def not_authenticated
    redirect_to admins_login_path, danger: t('flash.before_login')
  end
end
