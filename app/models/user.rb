class User < ActiveRecord::Base
  #attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_one :unread_feed, dependent: :destroy

  has_many :associations, dependent: :destroy

  has_many :ownerships, dependent: :destroy
  has_many :canvases, through: :ownerships 

  has_many :collaborations, dependent: :destroy 
  has_many :collaborators, through: :collaborations

  has_secure_password # use bcrypt for password encryption and makes authenticate method available

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, presence: true, length: { maximum: 20 } 
  validates :last_name, presence: true, length: { maximum: 20 } 
  validates :email, presence: true,
                      length: { maximum: 100 }, 
                      format: { with: EMAIL_REGEX }, 
                  uniqueness: { case_sensitive: false } 
  validates :password, presence: true, length: { minimum: 6 }, on: :update
  validates :password_confirmation, presence: true 
 
  before_save { |user| user.email = email.downcase }   
  
end
