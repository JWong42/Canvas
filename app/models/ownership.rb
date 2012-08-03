class Ownership < ActiveRecord::Base
  attr_accessible :canvas_id

  belongs_to :user
  belongs_to :canvas

  validates  :user_id, presence: true
  validates  :canvas_id, presence: true
end
