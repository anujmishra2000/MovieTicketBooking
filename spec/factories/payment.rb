FactoryBot.define do
  factory :payment do
    amount { 300.0 }
    sequence(:number) { |n|  "P12345#{n}" }
    status { 'success' }
    completed_at { Time.current }
    association :order
  end
end
