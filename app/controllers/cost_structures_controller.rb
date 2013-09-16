class CostStructuresController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @cost_structure = @canvas.cost_structures.create(content: params[:toSent])
    if @cost_structure.valid?
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'cost structures' component of #{@canvas.name} canvas."
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
        data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, item_content: @cost_structure.content, item_color: @cost_structure.tag_color, notification: content, emails: emails, type: 'item-create' }.to_json
        redis.publish('feeds', data)
        render json: { text: @cost_structure.id, color: @cost_structure.tag_color }
      end 
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @cost_structure = CostStructure.find(params[:id])
    @cost_structure.tag_color = params[:style]
    @canvas = Canvas.find(@cost_structure.canvas_id)
    if @cost_structure.save
      redis = Redis.new
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'cost structures' component of #{@canvas.name} canvas."
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
        data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, item_color: @cost_structure.tag_color, notification: content, emails: emails, type: 'item-update' }.to_json
        redis.publish('feeds', data)
        render :json => { :text => 'success' }
      end
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    @cost_structure = CostStructure.find(params[:id])
    @canvas = Canvas.find(@cost_structure.canvas_id)
    users = @canvas.users.where.not(email: current_user.email) # this needs to be extracted to reduce redundancy
    emails = users.map(&:email) # same for this as above
    @cost_structure.destroy
    redis = Redis.new
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'cost structures' component of #{@canvas.name} canvas."
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
      data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, notification: content, emails: emails, type: 'item-delete' }.to_json
      redis.publish('feeds', data)
      render json: { text: 'success' }
    end
  end 

end
