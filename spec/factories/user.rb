FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.unique.email }
    password { FFaker::Internet.password }
    role { 'customer' }
    confirmed_at { Time.current }

    trait :admin do
      name { FFaker::Name.name }
      email { FFaker::Internet.unique.email }
      password { FFaker::Internet.password }
      role { 'admin' }
      confirmed_at { Time.current }
    end
  end
end
