class Canvas < ActiveRecord::Base
  attr_accessible :name

  has_many :associations
  has_many :ownerships, dependent: :destroy
  has_many :users, through: :ownerships 
  has_many :invites, dependent: :destroy

  has_many :problems 
  has_many :customer_segments
  has_many :unique_value_propositions
  has_many :key_activities
  has_many :channels
  has_many :revenue_streams
  has_many :cost_structures
  has_many :key_metrics
  has_many :unfair_advantages

  validates :name, presence: true 
end
