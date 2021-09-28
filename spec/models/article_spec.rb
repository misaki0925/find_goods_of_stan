require 'rails_helper'

RSpec.describe Article, type: :model do
  xit '一意のtweet_urlが入力されている場合成功する' do
    article = Article.create(tweet_url: "https://twitter") 
    expect(article).to be_valid
  end

  xit 'tweet_urlがない場合失敗する' do
    article = Article.new(tweet_url: nil)
    article.valid?
    expect(article.errors[:tweet_url]).to include("can't be blank") 
  end

  it '同じtweet_urlが存在する場合失敗する' do
    article1 = create(:article, :with_tweet_url)
    article2 = build(:article, :with_tweet_url)
    article2.valid?
    expect(article2.errors[:tweet_url]).to include("has already been taken")
  end

  describe "dependent: :destroy" do
    let!(:member_1) {create(:member, :with_article) }
    let!(:member_2) {create(:member, :with_article) } 
    it 'dependent: :destroy' do
      expect{
      member_1.destroy
      }.to change{Member.count}.by(-1).and change{ArticleMember.count}.by(-1)
    end
  end
end


# has_many :article_members, dependent: :destroy ok
#   accepts_nested_attributes_for :article_members, allow_destroy: true これ自体いるのかあとd確認する

#   validates :tweet_url, uniqueness: true, presence: trueok
#   t.text :tweet_url, null: false, unique: true ok

