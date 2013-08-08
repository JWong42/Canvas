class UsersController < ApplicationController

  before_action :signed_in_user, only: [:show, :edit, :update] 
  before_action :correct_user,   only: [:show, :edit, :update]

  def new 
    @user = User.new 
  end 

  def create
    @user = User.new(user_params) 
    if @user.save
      session[:user_id] = @user.id 
      flash[:success] = "Welcome!"
      redirect_to user_path(@user)  
    else
      render 'new'
    end 
  end 

  def show
    @user = User.find(params[:id]) 
    @canvases = @user.canvases.order('updated_at DESC') 
  end 

  def edit 
    @user = User.find(params[:id])
  end 
 
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated" 
      redirect_to @user 
    else
      render 'edit'
    end 
  end 

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end 
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless @user == current_user
  end
 
end
