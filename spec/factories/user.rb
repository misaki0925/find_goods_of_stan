FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}example.com" }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      role { :admin }
    end

    trait :same_email do
    email {"same_name.example.com"}
    end

    trait :password_short do
      password { '1234' }
      password_confirmation { '1234' }
    end

    trait :deferent_password_confirmation do
      password { '1234' }
      password_confirmation { 'qwety' }
    end
  end
end
