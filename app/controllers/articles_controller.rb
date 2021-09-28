class ArticlesController < ApplicationController
  skip_before_action :require_login
  before_action :set_article, only: %i[show]
  
  def show;end

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result.includes(:members).published.order(created_at: :desc).page(params[:page]).per(6)
  end

  # def search
  #   # @q = Article.search(search_params)
  #   # @articles = @q.result.includes(:members).order(created_at: :desc).page(params[:page])
  #   index
  #   render :index
  # end
# ここスコープ使用する ここ代入しview作成する
  def home
    @articles = Article.published.all.limit(3).order(created_at: :desc)
    @kochi = Member.find(1).articles.published.last
    @kyomoto = Member.find(2).articles.published.last
    @tanaka = Member.find(3).articles.published.last
    @matsumura = Member.find(4).articles.published.last
    @jess = Member.find(5).articles.published.last
    @morimoto = Member.find(6).articles.published.last

    @member_articles = [@kochi,@kyomoto, @tanaka, @matsumura, @jess, @morimoto ]
  end


private

def set_article
  @article = Article.find(params[:id])
end 

def search_params
  params.require(:q).permit(:brand_cont, :members_name_cont, :status)
end

def set_name
  # 名前設定簡単にしたい最後にするか
end

end