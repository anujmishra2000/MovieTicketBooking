FactoryBot.define do
  factory :theatre do
    name { 'Theatre 1' }
    screen_type { 'imax' }
    seating_capacity { 100 }
    operational { true }
    contact_number { 9876543210 }
    sequence(:contact_email) { |n| "theatre_email+#{n}@gmail.com" }
  end
end
