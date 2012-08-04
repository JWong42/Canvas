module SessionsHelper
  def signed_in? 
    session[:user_id] ? true : false 
  end 

  def current_user 
    if !session[:user_id].nil?
      @current_user  ||= User.find(session[:user_id]) 
    else 
      @current_user = nil 
    end 
  end 

  def signed_in_user
    if self.current_user == nil 
      redirect_to signin_path, notice: "Please sign in." 
    end 
  end 

end 
