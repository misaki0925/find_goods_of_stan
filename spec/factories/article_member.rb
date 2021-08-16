FactoryBot.define do
  factory :article_member do
    association :article
    association :member
  end
end