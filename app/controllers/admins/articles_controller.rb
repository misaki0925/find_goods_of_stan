class Admins::ArticlesController < ApplicationController
  before_action :set_article, only: %i[ edit update destroy ]

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
    redirect_to admins_articles_path, notice: "記事内容を更新しました。"
  else
    flash.now[:update_error] = "記事内容を更新できませんでした。"
    render :edit
  end
end

def index
  @q = Article.ransack(params[:q])
  @articles = @q.result.includes(:members).order(created_at: :desc).page(params[:page])
end

def search
  @q = Article.search(search_params)
  @articles = @q.result.includes(:members).order(created_at: :desc).page(params[:page])
end

def destroy
  @article.images.purge
  @article.destroy
  redirect_to admins_articles_path, notice: "記事内容を削除しました。"
end

  private

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont)
end

def set_article
  @article = Article.find(params[:id])
end

def article_params
  params.require(:article).permit(:price, :brand, :item, :tweet_url, { member_ids: [] }, {images: []} )
end

end
