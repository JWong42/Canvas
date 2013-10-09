class CanvasesController < ApplicationController

  before_action :signed_in_user
  before_action :correct_canvas, only: [:show, :update, :destroy]

  def create
    @canvas = current_user.canvases.create(params[:canvas])
    if @canvas.valid? 
      content = "#{current_user.first_name} #{current_user.last_name} created a new canvas called - #{@canvas.name}."
      # write feed to database 
      Feed.create!(content: content, user_id: current_user.id, canvas_id: @canvas.id)
      Association.create!(user_id: current_user.id, canvas_id: @canvas.id)
      render json: { name: @canvas.name, id: @canvas.id, activity: content } 
    else
      render json: { name: 'fail' } 
    end 
  end 

  def show 
    @canvas = Canvas.find(params[:id]) 
    @notifications = get_notifications(current_user)
  end 

  def update 
    @canvas = Canvas.find(params[:id])
    old_name = @canvas.name
    if @canvas.update_attributes(name: params[:name])
      content = "#{current_user.first_name} #{current_user.last_name} changed name of #{old_name} to #{@canvas.name}."
      results = handle_feed(content, @canvas, current_user)
      data = { id: @canvas.id, name: @canvas.name, notification: content, emails: results["emails"], type: 'edit-name' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { name: @canvas.name, activity: content } 
    else
      render json: { name: 'fail' } 
    end 
  end 

  def destroy
    @canvas = Canvas.find(params[:id])
    content = "#{current_user.first_name} #{current_user.last_name} deleted #{@canvas.name}."
    results = handle_feed(content, @canvas, current_user)
    @canvas.destroy
    canvas_count = current_user.canvases.count
    data = { id: @canvas.id, count: canvas_count, notification: content, emails: results["emails"], type: 'delete-canvas' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    render json: { text: 'ok', count: canvas_count, activity: content } 
  end 

  private 

  def correct_canvas
    canvas = Canvas.find(params[:id])
    redirect_to root_path unless current_user.canvases.include?(canvas)
  end

end
