class Theatre < ApplicationRecord
  has_many :shows
  has_many :movies, through: :shows
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true, update_only: true

  validates :name, :screen_type, :seating_capacity, :contact_number, :contact_email, presence: true
  validates :contact_email, uniqueness: { case_sensitive: false }, email: true
  validates :seating_capacity, numericality: { only_integer: true }, allow_blank: true

  enum screen_type: {
    IMAX: 0,
    HD: 1,
    '4K_ULTRA': 2
  }

end
