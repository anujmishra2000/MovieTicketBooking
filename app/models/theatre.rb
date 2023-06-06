class Theatre < ApplicationRecord
  has_one :address

  validates :name, :screen_type, :seating_capacity, :contact_number, :contact_email, presence: true
  validates :contact_email, uniqueness: { case_sensitive: false }, email: true


end
