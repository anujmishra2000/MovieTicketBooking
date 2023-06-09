class Country < ApplicationRecord
  has_many :addresses, dependent: :restrict_with_error
  validates :name, :iso_code, presence: true
end
