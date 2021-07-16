class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show]
  
  def show;end

  def index
    # @articles = Article.all
    @q = Article.ransack(params[:q])
    # @members = Member.all
    @articles = @q.result.includes(:members)
  end

  def search
    @q = Article.search(search_params)
    @articles = @q.result.includes(:members)
  end

private

def set_article
  @article = Article.find(params[:id])
end 

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont)
end

end