class ChannelsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @channel = @canvas.channels.create(content: params[:toSent])
    if @channel.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'channels' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, item_content: @channel.content, item_color: @channel.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @channel.id, color: @channel.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.tag_color = params[:style]
    @canvas = Canvas.find(@channel.canvas_id)
    if @channel.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'channels' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, item_color: @channel.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    @channel = Channel.find(params[:id])
    @canvas = Canvas.find(@channel.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'channels' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'channels', item_id: @channel.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @channel.destroy
    render json: { text: 'success' }
  end
 
end
