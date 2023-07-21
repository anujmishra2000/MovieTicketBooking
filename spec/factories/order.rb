FactoryBot.define do
  factory :order do
    total { 300.0 }
    sequence(:number) { |n|  "O12345#{n}" }
    status { 'in_progress' }
    completed_at { Time.current }
    association :user
  end
end
