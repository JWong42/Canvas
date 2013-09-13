class StaticPagesController < ApplicationController

  def home 
    @notifications = get_notifications(current_user)
  end 

end
