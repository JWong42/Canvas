class Problem < ActiveRecord::Base
  attr_accessible :content
  belongs_to :canvas
end
