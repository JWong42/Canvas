class CanvasesController < ApplicationController

  before_action :signed_in_user
  #before_action :correct_user  

  def create
    @canvas = current_user.canvases.create(params[:canvas])
    if @canvas.valid? 
      redis = Redis.new 
      redis.publish('feeds', @canvas.to_json)
      render :json => { :name => @canvas.name, :id => @canvas.id } 
    else
      render :json => { :name => 'fail' } 
    end 
  end 

  def show 
    @canvas = Canvas.find(params[:id]) 
   #@ownership = @canvas.ownership.find_by(user_id: current_user)
  end 

  def update 
    @canvas = Canvas.find(params[:id])
    if @canvas.update_attributes(name: params[:name])
      render :json => { :name => @canvas.name, :id => @canvas.id } 
    else
      render :json => { :name => 'fail' } 
    end 
  end 

  def destroy
    Canvas.find(params[:id]).delete 
    @canvas_count = current_user.canvases.count
    render :json => { :text => 'ok', :count => @canvas_count } 
  end 

end
