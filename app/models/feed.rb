class Feed < ActiveRecord::Base
  validates  :content, presence: true
  validates  :user_id, presence: true
end
