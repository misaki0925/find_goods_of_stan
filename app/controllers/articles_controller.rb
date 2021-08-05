class ArticlesController < ApplicationController
  skip_before_action :require_login
  before_action :set_article, only: %i[show]
  
  def show;end

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result.includes(:members).order(created_at: :desc).page(params[:page])
  end

  def search
    # @q = Article.search(search_params)
    # @articles = @q.result.includes(:members).order(created_at: :desc).page(params[:page])
    index
    render :index
  end

  def line;end

  def home;end

private

def set_article
  @article = Article.find(params[:id])
end 

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont)
end

def set_name
  # 名前設定簡単にしたい最後にするか
end

end