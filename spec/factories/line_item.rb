FactoryBot.define do
  factory :line_item do
    quantity { 2 }
    unit_price { 150.0 }
    association :show
    association :order
  end
end
