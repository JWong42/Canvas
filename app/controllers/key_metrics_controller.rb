class KeyMetricsController < ApplicationController

   def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_metric = @canvas.key_metrics.create(content: params[:toSent])
    if @key_metric.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'key metrics' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      feed = Feed.new(content: content, user_id: current_user.id, canvas_id: @canvas.id)
      data = { canvas_id: @canvas.id, component: 'key_metrics', item_id: @key_metric.id, item_content: @key_metric.content, item_color: @key_metric.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @key_metric.id, color: @key_metric.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @key_metric = KeyMetric.find(params[:id])
    @key_metric.tag_color = params[:style]
    @canvas = Canvas.find(@key_metric.canvas_id)
    if @key_metric.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'key metrics' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'key_metrics', item_id: @key_metric.id, item_color: @key_metric.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy 
    @key_metric = KeyMetric.find(params[:id])
    @canvas = Canvas.find(@key_metric.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'key metrics' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'key_metrics', item_id: @key_metric.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @key_metric.destroy
    render json: { text: 'success' }
  end 

end
