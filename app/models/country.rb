class Country < ApplicationRecord
  has_many :addresses

  validates :name, :iso_code, presence: true
  validates_length_of :pincode, is: 6, allow_blank: true
end
