class Address < ApplicationRecord
  belongs_to :theatre
  belongs_to :country

  validates :street, :state, :city, :pincode, presence: true
  validates_length_of :pincode, is: 6, allow_blank: true
end
