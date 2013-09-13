class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :canvas

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates  :user_id, presence: true
  validates  :canvas_id, presence: true
  validates  :name, presence: true
  validates  :email, presence: true,
                     length: { maximum: 100 },
                     format: { with: EMAIL_REGEX }
                     #,uniqueness: { case_sensitive: false }
  validates  :status, presence: true

  before_save { |invite| invite.email = email.downcase }
end
