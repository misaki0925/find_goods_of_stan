FactoryBot.define do
  factory :member, class: Member do
    sequence(:name) { |n| "name-#{n}" }

    trait :with_article do
      after(:create) do |member|
        create_list(:article_member, 1, member: member, article: create(:article))
      end
    end
  end

  factory :member_same_name, class: Member do
    name {"same_name"}
  end
end
