class Canvas < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :ownerships
  has_many :users, through: :ownerships 

  has_many :problems 
  has_many :customer_segments
  has_many :unique_value_propositions
  has_many :key_activities
  has_many :channels
  has_many :revenue_streams
  has_many :cost_structure
  has_many :key_metrics
  has_many :unfair_advantages
end
