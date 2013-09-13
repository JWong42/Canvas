class UsersController < ApplicationController

  before_action :signed_in_user, only: [:show, :edit, :update, :invites] 
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
    @invites_count = Invite.where(email: @user.email, status: 'Invite Pending').count
    @user_activities = Feed.where(user_id: @user.id).order("created_at DESC")
    @notifications = get_notifications(@user)
  end 

  def edit 
    @user = User.find(params[:id])
  end 
 
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      content = "#{current_user.first_name} #{current_user.last_name} updated profile information."
      Feed.create!(content: content, user_id: current_user.id)
      flash[:success] = "Profile updated" 
      redirect_to @user 
    else
      render 'edit'
    end 
  end 

  def invites 
    @invites = Invite.where(email: current_user.email, status: 'Invite Pending')
    invites_count = @invites.length
    # rendering json format of an instance variable along with its multiple associations while limiting to certain attributes
    render json: { invites_count: invites_count, invites: @invites.as_json( include: [
                                                                              { canvas: { only: :name } },
                                                                              { user: { only: [ :first_name, :last_name ] } } 
                                                                            ] ) } 
    #render json: @invites.as_json( include: [
                                              #{ canvas: { only: :name } },
                                              #{ user: { only: [ :first_name, :last_name ] } } 
                                            #] )  
    #render partial: "users/invites.json"
  end 

  private 

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :unread_feeds_count, :unread_feeds)
  end 
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless @user == current_user
  end
 
end
