class Theatre < ApplicationRecord
  has_many :shows, dependent: :restrict_with_error
  has_many :movies, through: :shows
  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :address, allow_destroy: true, update_only: true

  validates :name, :screen_type, :seating_capacity, :contact_number, :contact_email, presence: true
  validates :contact_number, contact_number: true, allow_blank: true
  validates :contact_email, uniqueness: { case_sensitive: false }, email: true, allow_blank: true
  validates :seating_capacity, numericality: { only_integer: true }, allow_blank: true

  enum screen_type: {
    'imax': 0,
    'hd': 1,
    '4k_ultra': 2
  }

end
