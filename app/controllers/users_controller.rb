class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:show, :edit, :update] 
  before_filter :correct_user,   only: [:show, :edit, :update]

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
    @canvases = @user.canvases.order('updated_at DESC') 
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

  private 

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless @user == current_user 
  end 

end
