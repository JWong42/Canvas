class Collaboration < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :user 
  # No table named collaborator - use User table instead
  belongs_to :collaborator, class_name: "User" 

  validates  :user_id, presence: true
  validates  :collaborator_id, presence: true   

end
