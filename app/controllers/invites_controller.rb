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
end
