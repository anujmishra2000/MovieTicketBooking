FactoryBot.define do
  factory :order do
    total { FFaker::Number.decimal }
    sequence(:number) { |n|  "O12345#{n}" }
    status { 'in_progress' }
    completed_at { Time.current }
    association :user
  end
end
