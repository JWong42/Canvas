module SessionsHelper
  def signed_in? 
    session[:user_id] ? true : false 
  end 

  def current_user 
    @current_user  ||= User.find(session[:user_id]) 
  end 

end 
