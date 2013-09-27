class CustomerSegmentsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @customer_segment = @canvas.customer_segments.create(content: params[:toSent])
    if @customer_segment.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'customer segments' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'customer_segments', item_id: @customer_segment.id, item_content: @customer_segment.content, item_color: @customer_segment.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @customer_segment.id, color: @customer_segment.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @customer_segment = CustomerSegment.find(params[:id])
    @customer_segment.tag_color = params[:style]
    @canvas = Canvas.find(@customer_segment.canvas_id)
    if @customer_segment.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'customer segments' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'customer_segments', item_id: @customer_segment.id, item_color: @customer_segment.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    @customer_segment = CustomerSegment.find(params[:id])
    @canvas = Canvas.find(@customer_segment.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'customer segments' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'customer_segments', item_id: @customer_segment.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @customer_segment.destroy
    render json: { text: 'success' }
  end

end
