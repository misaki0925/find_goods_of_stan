FactoryBot.define do
  factory :article do
    sequence(:price) { |n| "¥10000#{n}-" }
    sequence(:brand) { |n| "test_brand_#{n}" }
    sequence(:item) { |n| "test_item_#{n}" }
    sequence(:tweet_url) { |n| "twitter.com_#{n}" }

    # after(:create) do |article|
    #   image_urls = ['spec/fixtures/test_image1.jpeg', 'spec/fixtures/test_image2.jpeg']
    #   image_urls.each_with_index do |image_url, i|
    #     io = open(image_url)
    #     article.images.attach(io: io, filename: "#{article.id}_#{i}")
    #   end
    # end

# 画像
# medias = tweet.media
# image_urls = medias.map{ |h| h.media_url_https }
# # LINE送信用の画像url作成
# imgae_url_for_line = image_urls.first
# @imgae_url_for_line_small = "#{imgae_url_for_line}:small"
# # 画像をActiveStorageに保存
# image_urls.each_with_index do |image_url, i|
#   image_url_small = "#{image_url}:small"
#   io = open(image_url_small)
#   @article.images.attach(io: io, filename: "#{@article.id}_#{i}")

# # ここまで  ---------
    # end
    trait :no_tweet_url do
      tweet_url { "" }
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end

    trait :with_member do
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end

    trait :with_members do
      after(:create) do |article|
        create_list(:article_member, 1 , article: article, member: create(:members))

      end
    end

    trait :same_brand do
      brand {"same_brand"}
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end

    trait :same_member do
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member_same_name))
      end
    end

    trait :with_tweet_url do
      tweet_url {"https://twitter.com/2jkhs6/status/1424628117360943107"}
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end

    trait :with_tweet_url_2 do
      tweet_url {"https://twitter.com/2jkhs6/status/1403743268001615874"}
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end
  end
end
