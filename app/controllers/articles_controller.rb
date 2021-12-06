class ArticlesController < ApplicationController
  skip_before_action :require_login
  before_action :set_article, only: %i[show]
  before_action :set_item_search, only: %i[index]
  
  def show;end

  def index
    @articles = @set_items.includes(:members).published.order(created_at: :desc).page(params[:page]).per(6)
  end

  def home
    @articles = Article.published.all.limit(3).order(created_at: :desc)
    @each_member_articles = []
    @each_member_names = []
    ids =  Member.all.ids
    ids.each do |id|
      last_item = Member.find(id).articles.published.last
      name = Member.find(id).name
      @each_member_articles.push(last_item)
      @each_member_names.push(name)
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end 

end
