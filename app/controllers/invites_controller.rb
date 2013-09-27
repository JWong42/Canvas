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
    @canvas = Canvas.find(@invite.canvas_id)
    @invite.user_id = current_user.id  
    if @invite.save
      content = "#{current_user.first_name} #{current_user.last_name} invited #{@invite.name} to #{@invite.canvas.name}."
      results = handle_feed(content, @canvas, current_user, @invite.email)
      data = { id: results["invited_user_id"], invites_count: results["invites_count"], notification: content, emails: results["emails"], type: 'invite-sent' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { status: 'success!', invite: { name: @invite.name, email: @invite.email, status: @invite.status, activity: content } } 
      InviteMailer.delay.invite_email(@invite.id, current_user.id) # using sidekiq to send this into background
    else
      render json: { status: 'error!', invite: @invite.errors.messages } 
    end 
  end 

  def update 
    @invite = Invite.find(params[:id])
    @canvas = Canvas.find(@invite.canvas_id)
    confirm = params[:confirm] 
    invites_count = Invite.where(email: current_user.email, status: 'Invite Pending').count - 1
    redis = Redis.new
    if confirm == 'accept' 
      @invite.update_attributes!(status: 'Invite Accepted') 
      params[:ownership] = { user_id: current_user.id, canvas_id: params[:canvas] } 
      @ownership = Ownership.create(ownership_params)
      content = "#{current_user.first_name} #{current_user.last_name} accepted to collaborate on #{@invite.canvas.name}."
      results = handle_feed(content, @canvas, current_user)
      data = { notification: content, emails: results["emails"], type: 'invite-accepted' }.to_json
      redis.publish('feeds', data)
      render json: { invite: 'accepted', count: invites_count, activity: content }  
    elsif confirm == 'decline' 
      @invite.update_attributes!(status: 'Invite Declined') 
      content = "#{current_user.first_name} #{current_user.last_name} declined to collaborate on #{@invite.canvas.name}."
      results = handle_feed(content, @canvas, current_user)
      data = { notification: content, emails: results["emails"], type: 'invite-declined' }.to_json
      redis.publish('feeds', data)
      render json: { invite: 'declined', count: invites_count, activity: content }  
    end 
  end 

  private 
    
    def ownership_params
      params.require(:ownership).permit(:user_id, :canvas_id)
    end 
end
