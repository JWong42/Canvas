class UnfairAdvantagesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unfair_advantage = @canvas.unfair_advantages.create(content: params[:toSent])
    if @unfair_advantage.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'unfair advantages' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'unfair_advantages', item_id: @unfair_advantage.id, item_content: @unfair_advantage.content, item_color: @unfair_advantage.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @unfair_advantage.id, color: @unfair_advantage.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @unfair_advantage = UnfairAdvantage.find(params[:id])
    @unfair_advantage.tag_color = params[:style]
    @canvas = Canvas.find(@unfair_advantage.canvas_id)
    if @unfair_advantage.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'unfair advantages' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'unfair_advantages', item_id: @unfair_advantage.id, item_color: @unfair_advantage.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    @unfair_advantage = UnfairAdvantage.find(params[:id])
    @canvas = Canvas.find(@unfair_advantage.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'unfair advantages' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'unfair_advantages', item_id: @unfair_advantage.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @unfair_advantage.destroy
    render json: { text: 'success' }
  end

end
