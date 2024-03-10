FactoryBot.define do
  factory :country do
    name { FFaker::AddressIN.country }
    iso_code { 'IND' }
  end
end
