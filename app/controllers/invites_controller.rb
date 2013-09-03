class InvitesController < ApplicationController

  def index 
    @canvas = Canvas.find(params[:canvas_id])
    @invites = @canvas.invites 
    unless @invites.empty? 
      render json: { status: 'success!', invites: @invites } 
    else
      render json: { status: 'error!' } 
    end 
  end 

  def create
    @invite = Invite.new(params[:invite])
    @invite.user_id = current_user.id  
    if @invite.save
      render json: { status: 'success!', invite: { name: @invite.name, email: @invite.email, status: @invite.status } } 
      InviteMailer.invite_email(@invite, current_user).deliver
    else
      render json: { status: 'error!', invite: @invite.errors.messages } 
    end 
  end 

  def update 
    @invite = Invite.find(params[:id])
    confirm = params[:confirm] 
    invites_count = Invite.where(email: current_user.email, status: 'Invite Pending').count - 1
    if confirm == 'accept' 
      @invite.update_attributes!(status: 'Invite Accepted') 
      params[:ownership] = { user_id: current_user.id, canvas_id: params[:canvas] } 
      @ownership = Ownership.create(ownership_params)
      render json: { invite: 'accepted', count: invites_count }  
    elsif confirm == 'decline' 
      @invite.update_attributes!(status: 'Invite Declined') 
      render json: { invite: 'declined', count: invites_count }  
    end 
  end 

  private 
    
    def ownership_params
      params.require(:ownership).permit(:user_id, :canvas_id)
    end 
end
