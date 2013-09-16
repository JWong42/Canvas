class CanvasesController < ApplicationController

  before_action :signed_in_user
  #before_action :correct_user  

  def create
    @canvas = current_user.canvases.create(params[:canvas])
    if @canvas.valid? 
      content = "#{current_user.first_name} #{current_user.last_name} created a new canvas called - #{@canvas.name}."
      # write feed to database 
      Feed.create!(content: content, user_id: current_user.id, canvas_id: @canvas.id)
      Association.create!(user_id: current_user.id, canvas_id: @canvas.id)
      render json: { name: @canvas.name, id: @canvas.id, activity: content } 
    else
      render json: { name: 'fail' } 
    end 
  end 

  def show 
    @canvas = Canvas.find(params[:id]) 
    @notifications = get_notifications(current_user)
  end 

  def update 
    @canvas = Canvas.find(params[:id])
    old_name = @canvas.name
    if @canvas.update_attributes(name: params[:name])
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} changed name of #{old_name} to #{@canvas.name}."
      feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @canvas.id)
      if feed.save
        users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
        emails = users.map(&:email)  # same for this as above
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
        data = { id: @canvas.id, name: @canvas.name, notification: content, emails: emails, type: 'edit-name' }.to_json
        redis.publish('feeds', data)
        render json: { name: @canvas.name, activity: content } 
      end 
    else
      render json: { name: 'fail' } 
    end 
  end 

  def destroy
    @canvas = Canvas.find(params[:id])
    users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
    emails = users.map(&:email) # same for this as above
    @canvas.destroy
    canvas_count = current_user.canvases.count
    redis = Redis.new
    content = "#{current_user.first_name} #{current_user.last_name} deleted #{@canvas.name}."
    feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @canvas.id)
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
      data = { id: @canvas.id, count: canvas_count, notification: content, emails: emails, type: 'delete-canvas' }.to_json
      redis.publish('feeds', data)
      render json: { text: 'ok', count: canvas_count, activity: content } 
    end
  end 

end
