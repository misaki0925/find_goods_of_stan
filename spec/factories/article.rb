FactoryBot.define do
  factory :article do
    sequence(:tweet_url) { |n| "https://twitter.com/2jkhs6/status/139717686878098637#{n}" }
    sequence(:brand) { |n| "brand_#{n}" }

    trait :with_member do
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
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
      tweet_url {"https://twitter.com/2jkhs6/status/1397176868780986370"}
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end

    trait :with_images do
      after(:build) do |article|
        article.images.attach(io: File.open('spec/fixtures/test_image1.jpeg'),filename: 'test_image1.jpeg')
        article.images.attach(io: File.open('spec/fixtures/test_image2.jpeg'),filename: 'test_image2.jpeg')
      end
    end
  end
end
