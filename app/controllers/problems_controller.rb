class ProblemsController < ApplicationController

  def create 
    @canvas = Canvas.find(params[:canvas_id])
    @problem = @canvas.problems.create(content: params[:toSent])
    if @problem.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'problems' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'problems', item_id: @problem.id, item_content: @problem.content, item_color: @problem.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @problem.id, color: @problem.tag_color } 
    else
      render json: { text: 'fail' } 
    end 
  end 

  def update 
    @problem = Problem.find(params[:id])
    @problem.tag_color = params[:style]
    @canvas = Canvas.find(@problem.canvas_id)
    if @problem.save 
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'problems' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'problems', item_id: @problem.id, item_color: @problem.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    @problem = Problem.find(params[:id])
    @canvas = Canvas.find(@problem.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'problems' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'problems', item_id: @problem.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @problem.destroy
    render json: { text: 'success' }
  end

end
