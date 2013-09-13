class Association < ActiveRecord::Base
  belongs_to :user
  belongs_to :canvas

  validates  :user_id, presence: true
  validates  :canvas_id, presence: true
end
