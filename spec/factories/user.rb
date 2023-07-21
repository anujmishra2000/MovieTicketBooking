FactoryBot.define do
  factory :user do
    name { 'Anuj' }
    sequence(:email) { |n| "email+#{n}@gmail.com" }
    password { '1234567' }
    role { 'customer' }
    confirmed_at { Time.current }

    trait :admin do
      name { 'admin' }
      sequence(:email) { |n| "admin_email+#{n}@gmail.com" }
      password { '1234567' }
      role { 'admin' }
    end
  end
end
