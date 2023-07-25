FactoryBot.define do
  factory :address do
    street { 'Patel Nagar' }
    city { 'New Delhi' }
    state { 'Delhi' }
    pincode { 110001 }
    association :theatre
    association :country
  end
end
