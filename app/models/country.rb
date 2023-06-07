class Country < ApplicationRecord
  has_many :addresses

  validates :name, :iso_code, presence: true
end
