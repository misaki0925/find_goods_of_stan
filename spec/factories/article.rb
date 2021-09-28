FactoryBot.define do
  factory :article do
    # sequence(:price) { |n| "¥10000#{n}-" }
    # sequence(:brand) { |n| "test_brand_#{n}" }
    # sequence(:item) { |n| "test_item_#{n}" }
    sequence(:tweet_url) { |n| "twitter.com_#{n}" }
    

    trait :with_member do
      after(:create) do |article|
        create_list(:article_member, 1, article: article, member: create(:member))
      end
    end


    trait :with_members do
      after(:build) do |article|
        article.members << build(:member)
        article.members << build(:member_same_name)
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

    trait :with_tweet_url_2 do
      tweet_url {"https://twitter.com/2jkhs6/status/1396831724005330946"}
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
