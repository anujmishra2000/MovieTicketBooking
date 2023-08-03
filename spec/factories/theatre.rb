FactoryBot.define do
  factory :theatre do
    name { FFaker::Name.name }
    screen_type { 'imax' }
    seating_capacity { FFaker::Number.number(digits: 2) }
    operational { true }
    contact_number { FFaker::Number.number(digits: 10) }
    contact_email { FFaker::Internet.unique.email }
  end
end
