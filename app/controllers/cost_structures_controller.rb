class CostStructuresController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @cost_structure = @canvas.cost_structures.create(content: params[:toSent])
    if @cost_structure.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'cost structures' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, item_content: @cost_structure.content, item_color: @cost_structure.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @cost_structure.id, color: @cost_structure.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @cost_structure = CostStructure.find(params[:id])
    @cost_structure.tag_color = params[:style]
    @canvas = Canvas.find(@cost_structure.canvas_id)
    if @cost_structure.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'cost structures' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, item_color: @cost_structure.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    @cost_structure = CostStructure.find(params[:id])
    @canvas = Canvas.find(@cost_structure.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'cost structures' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'cost_structures', item_id: @cost_structure.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @cost_structure.destroy
    render json: { text: 'success' }
  end 

end
