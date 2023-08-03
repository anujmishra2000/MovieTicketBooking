FactoryBot.define do
  factory :show do
    start_time { 7.hours.from_now }
    price { FFaker::Number.decimal }
    status { 'active' }
    seats_available { FFaker::Number.number }
    association :theatre
    association :movie
  end
end
