class Admins::ArticlesController < ApplicationController
# before_action :set_article, only[:edit, :update]
before_action :set_articles

#   def edit;end

def index
  @q = Article.ransack(params[:q])
  @articles = @q.result.includes(:members)
end

def search
  @q = Article.search(search_params)
  @articles = @q.result.includes(:members)
end

#   def update
#     @article.update(article_params)
#     if @article.save
#       redirect_to '詳細ページパスarticle/show'
#     else
#       render :edit
#     end
#   end

  private

  # def set_article
  #   @articles = Article.all
  # end

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont)
end

#   def set_article
#     @article = Article.find(params[:id])
#   end

#   def article_params
#     params.require(:article).permit(:price, :brand, :tweet_url, :members[])
#   end
end
