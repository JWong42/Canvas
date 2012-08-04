class SessionsController < ApplicationController

  def new 

  end 

  def create
    user = User.find_by_email(params[:email])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect_to user  
    else
      flash.now[:error] = "Invalid email or password."
      render 'new'
    end 
  end 

  def destroy 
     session[:user_id] = nil 
     redirect_to root_path 
  end 

end
