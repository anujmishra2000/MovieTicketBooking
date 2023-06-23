class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :confirmable

  has_many :orders, dependent: :restrict_with_error
  
  enum role: { 'customer': 0, 'admin': 1 }
end
