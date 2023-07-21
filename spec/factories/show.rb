FactoryBot.define do
  factory :show do
    start_time { 7.hours.from_now }
    end_time { 8.hours.from_now }
    price { 150.0 }
    status { 'active' }
    seats_available { 100 }
    association :theatre
    association :movie
  end
end
