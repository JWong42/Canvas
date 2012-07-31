class Ownership < ActiveRecord::Base
  # attr_accessible :user_id, :canvas_id

  belongs_to :user
  belongs_to :canvans

  validates  :user_id, presence: true
  validates  :canvas_id, presence: true
end
