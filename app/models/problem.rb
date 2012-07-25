class Problem < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :canvas
end
