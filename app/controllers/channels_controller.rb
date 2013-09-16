class ChannelsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @channel = @canvas.channels.create(content: params[:toSent])
    if @channel.valid?
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'channels' component of #{@canvas.name} canvas."
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
        data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, item_content: @channel.content, item_color: @channel.tag_color, notification: content, emails: emails, type: 'item-create' }.to_json
        redis.publish('feeds', data)
        render json: { text: @channel.id, color: @channel.tag_color }
      end
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.tag_color = params[:style]
    @canvas = Canvas.find(@channel.canvas_id)
    if @channel.save
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'channels' component of #{@canvas.name} canvas."
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
        data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, item_color: @channel.tag_color, notification: content, emails: emails, type: 'item-update' }.to_json
        redis.publish('feeds', data)
        render :json => { :text => 'success' }
      end
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    @channel = Channel.find(params[:id])
    @canvas = Canvas.find(@channel.canvas_id)
    users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
    emails = users.map(&:email) # same for this as above
    @channel.destroy
    redis = Redis.new
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'channels' component of #{@canvas.name} canvas."
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
      data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, notification: content, emails: emails, type: 'item-delete' }.to_json
      redis.publish('feeds', data)
      render json: { text: 'success' }
    end
  end
 
end
