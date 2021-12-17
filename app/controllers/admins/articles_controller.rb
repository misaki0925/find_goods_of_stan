class Admins::ArticlesController < ApplicationController
  before_action :set_article, only: %i[ edit update destroy ]
  before_action :set_item_search, only: %i[index]

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if params[:article][:image_ids]
      params[:article][:image_ids].each do |image_id|
        image = @article.images.find(image_id)
        image.purge #ファイルを削除する
      end
    end
    if @article.update_attributes(article_params)
      redirect_to admins_articles_path, notice: t('flash.updated')
    else
      flash.now[:update_error] = t('flash.not_updated')
      render :edit
    end
  end

  def index
    @articles = @set_items.includes(:members).order(created_at: :desc).page(params[:page])
  end

  def destroy
    @article.images.purge
    @article.destroy!
    redirect_to admins_articles_path, danger: t('flash.deleted')
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:price, :brand, :item, :tweet_url, :line_image_url, :status, { member_ids: [] }, {images: []} )
    end
end
