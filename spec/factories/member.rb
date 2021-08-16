FactoryBot.define do
  factory :member, class: Member do
    sequence(:name) { |n| "name-#{n}" }
  end

  factory :member_same_name, class: Member do
    name { "same_name" }
  end

  factory :members, class: Member do
    name { ["name_1", "name_2"] }
  end
end
