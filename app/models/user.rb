class User < ApplicationRecord
  include Tokenizable
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :confirmable

  has_many :orders, dependent: :restrict_with_error
  has_many :reactions, class_name: 'UserReaction', dependent: :destroy

  enum role: { 'customer': 0, 'admin': 1 }

  def after_confirmation
    update(auth_token: generate_token(:auth))
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["email"]
  end
end
