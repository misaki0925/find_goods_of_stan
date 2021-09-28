FactoryBot.define do
  factory :report, class: Report do
    comment { 'test_text' }
  end

  factory :report_no_comment, class: Report do
    comment { '' }
  end
end
