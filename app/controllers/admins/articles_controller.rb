class Admins::ArticlesController < ApplicationController
  before_action :set_article, only: %i[edit update destroy ]

def edit;end

def update
  @article = Article.find(params[:id])
  if params[:article][:image_ids]
    params[:article][:image_ids].each do |image_id|
      image = @article.images.find(image_id)
      image.purge
    end
  end
  if @article.update_attributes(article_params)
    redirect_to admins_articles_path
  else
    render :edit
  end
end

def index
  @q = Article.ransack(params[:q])
  @articles = @q.result.includes(:members)
end

def search
  @q = Article.search(search_params)
  @articles = @q.result.includes(:members)
end

def destroy

end

  private

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont)
end

def set_article
  @article = Article.find(params[:id])
end

def article_params
  params.require(:article).permit(:price, :brand, :tweet_url, { member_ids: [] }, {images: []} )
end

end
