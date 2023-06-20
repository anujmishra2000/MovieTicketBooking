class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :confirmable

  has_many :orders, dependent: :restrict_with_error
  has_many :cancelled_orders, foreign_key: :cancelled_by_user_id, class_name: 'Order', dependent: :restrict_with_error

  enum role: { 'customer': 0, 'admin': 1 }
end
