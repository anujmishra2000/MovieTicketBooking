# require 'ffaker'
FactoryBot.define do
  factory :line_item do
    quantity { FFaker::Number.number }
    unit_price { FFaker::Number.decimal }
    association :show
    association :order
  end
end
