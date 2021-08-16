FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      role { :admin }
    end
  end
end
