class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_many :canvases

  has_secure_password # use bcrypt for password encryption and makes authenticate method available

  EMAIL_REGEX = /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i

  validates :first_name, presence: true, length: { maximum: 20 } 
  validates :last_name, presence: true, length: { maximum: 20 } 
  validates :email, presence: true,
                      length: { maximum: 100 }, 
                      format: { with: EMAIL_REGEX }, 
                  uniqueness: { case_sensitive: false } 
  # validates :password, presence: true, length: { minimum: 6 } 
  validates :password_confirmation, presence: true 
 
  before_save { |user| user.email = email.downcase }   
  
end
