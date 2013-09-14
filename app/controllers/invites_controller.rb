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
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} invited #{@invite.name} to #{@invite.canvas.name}."
      feed = Feed.new(content: content, user_id: @invite.user_id, canvas_id: @invite.canvas_id)
      if feed.save
        @canvas = Canvas.find(@invite.canvas_id)
        users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
        user = User.where(email: @invite.email).first # check if potential collaborator already registered an account
        unless user.blank?
          users << user
          user_id = user.id
          Association.create!(user_id: user_id, canvas_id: @canvas.id)
          invites_count = Invite.where(email: user.email, status: 'Invite Pending').count 
        end 
        emails = users.map(&:email)  # same for this as above
        emails = emails.to_set
        users.each do |user|
          if user.unread_feed.nil?
            UnreadFeed.create!(user_id: user.id, count: 1, list: [feed.id])
          else
            unread_feed = user.unread_feed
            unread_feed_count = unread_feed.count + 1
            unread_feed_list = unread_feed.list + [feed.id]
            unread_feed.update_attributes!(user_id: user.id, count: unread_feed_count, list: unread_feed_list)
          end
        end 
        data = { id: user_id, invites_count: invites_count, notification: content, emails: emails, type: 'invite-sent' }.to_json
        redis.publish('feeds', data)
        render json: { status: 'success!', invite: { name: @invite.name, email: @invite.email, status: @invite.status, activity: content } } 
        InviteMailer.delay.invite_email(@invite.id, current_user.id) # using sidekiq to send this into background
      end 
    else
      render json: { status: 'error!', invite: @invite.errors.messages } 
    end 
  end 

  def update 
    @invite = Invite.find(params[:id])
    @canvas = Canvas.find(@invite.canvas_id)
    users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
    emails = users.map(&:email)  # same for this as above
    confirm = params[:confirm] 
    invites_count = Invite.where(email: current_user.email, status: 'Invite Pending').count - 1
    redis = Redis.new
    if confirm == 'accept' 
      @invite.update_attributes!(status: 'Invite Accepted') 
      params[:ownership] = { user_id: current_user.id, canvas_id: params[:canvas] } 
      @ownership = Ownership.create(ownership_params)
      content = "#{current_user.first_name} #{current_user.last_name} accepted to collaborate on #{@invite.canvas.name}."
      feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @invite.canvas_id)
      if feed.save 
        users.each do |user|
          if user.unread_feed.nil?
            UnreadFeed.create!(user_id: user.id, count: 1, list: [feed.id])
          else
            unread_feed = user.unread_feed
            unread_feed_count = unread_feed.count + 1
            unread_feed_list = unread_feed.list + [feed.id]
            unread_feed.update_attributes!(user_id: user.id, count: unread_feed_count, list: unread_feed_list)
          end
        end
        data = { notification: content, emails: emails, type: 'invite-accepted' }.to_json
        redis.publish('feeds', data)
        render json: { invite: 'accepted', count: invites_count, activity: content }  
      end 
    elsif confirm == 'decline' 
      @invite.update_attributes!(status: 'Invite Declined') 
      content = "#{current_user.first_name} #{current_user.last_name} declined to collaborate on #{@invite.canvas.name}."
      feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @invite.canvas_id)
      if feed.save
        users.each do |user|
          if user.unread_feed.nil?
            UnreadFeed.create!(user_id: user.id, count: 1, list: [feed.id])
          else
            unread_feed = user.unread_feed
            unread_feed_count = unread_feed.count + 1
            unread_feed_list = unread_feed.list + [feed.id]
            unread_feed.update_attributes!(user_id: user.id, count: unread_feed_count, list: unread_feed_list)
          end
        end
        data = { notification: content, emails: emails, type: 'invite-declined' }.to_json
        redis.publish('feeds', data)
        render json: { invite: 'declined', count: invites_count, activity: content }  
      end 
    end 
  end 

  private 
    
    def ownership_params
      params.require(:ownership).permit(:user_id, :canvas_id)
    end 
end
