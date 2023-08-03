FactoryBot.define do
  factory :address do
    street { FFaker::Address.street_address }
    city { FFaker::AddressIN.city }
    state { FFaker::AddressIN.state }
    pincode { FFaker::AddressIN.pincode }
    association :theatre
    association :country
  end
end
