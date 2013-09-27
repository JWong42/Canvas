class KeyActivitiesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_activity = @canvas.key_activities.create(content: params[:toSent])
    if @key_activity.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'key activities' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @canvas.id)
      data = { canvas_id: @canvas.id, component: 'key_activities', item_id: @key_activity.id, item_content: @key_activity.content, item_color: @key_activity.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @key_activity.id, color: @key_activity.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @key_activity = KeyActivity.find(params[:id])
    @key_activity.tag_color = params[:style]
    @canvas = Canvas.find(@key_activity.canvas_id)
    if @key_activity.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'key activities' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'key_activities', item_id: @key_activity.id, item_color: @key_activity.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    @key_activity = KeyActivity.find(params[:id])
    @canvas = Canvas.find(@key_activity.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'key activities' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'key_activities', item_id: @key_activity.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @key_activity.destroy
    render json: { text: 'success' }
  end

end
