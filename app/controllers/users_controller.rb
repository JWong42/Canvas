class UsersController < ApplicationController

  def index 

  end 

  def new 
    @user = User.new 
  end 

  def create
    @user = User.new(params[:user]) 
    if @user.save
      flash[:success] = "Welcome!"
      redirect_to root_path 
    else
      render 'new'
    end 
  end 

  def show
    @user = User.find(params[:id]) 
    @canvases = @user.canvases 
  end 

  def edit 
    @user = User.find(params[:id])
  end 
 
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated" 
      redirect_to @user 
    else
      render 'edit'
    end 
  end 

end
