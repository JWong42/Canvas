class RevenueStreamsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @revenue_stream = @canvas.revenue_streams.create(content: params[:toSent])
    if @revenue_stream.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'revenue streams' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'revenue_streams', item_id: @revenue_stream.id, item_content: @revenue_stream.content, item_color: @revenue_stream.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @revenue_stream.id, color: @revenue_stream.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @revenue_stream = RevenueStream.find(params[:id])
    @revenue_stream.tag_color = params[:style]
    @canvas = Canvas.find(@revenue_stream.canvas_id)
    if @revenue_stream.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'revenue streams' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'revenue_streams', item_id: @revenue_stream.id, item_color: @revenue_stream.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy 
    @revenue_stream = RevenueStream.find(params[:id])
    @canvas = Canvas.find(@revenue_stream.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'revenue streams' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'revenue_streams', item_id: @revenue_stream.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @revenue_stream.destroy
    render json: { text: 'success' } 
  end 

end
