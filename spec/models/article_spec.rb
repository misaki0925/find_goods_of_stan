require 'rails_helper'
RSpec.describe Article, type: :model do
  it '一意のtweet_urlが入力されている場合成功する' do
    article = Article.create(tweet_url: "https://twitter") 
    expect(article).to be_valid
  end

  it 'tweet_urlがない場合失敗する' do
    article = Article.new(tweet_url: nil)
    article.valid?
    expect(article.errors[:tweet_url]).to include(I18n.t('errors.messages.blank'))
  end

  it '同じtweet_urlが存在する場合失敗する' do
    article1 = create(:article, :with_tweet_url)
    article2 = build(:article, :with_tweet_url)
    article2.valid?
    expect(article2.errors[:tweet_url]).to include(I18n.t('errors.messages.taken'))
  end

  describe "dependent: :destroyが有効か" do
    let!(:article) {create(:article, :with_member) }
    it 'Articleを削除したらArticleMemberも削除される' do
      expect{
      article.destroy
      }.to change{Article.count}.by(-1).and change{ArticleMember.count}.by(-1)
    end
  end
end
