class CanvasesController < ApplicationController

  def new 
  end 

  def create
    @canvas = current_user.canvases.create(params[:canvas])
    if @canvas.valid? 
      render :json => { :name => @canvas.name, :id => @canvas.id } 
    else
      render :json => { :name => 'fail' } 
    end 
  end 

  def update 
    @canvas = Canvas.find(params[:id])
    if @canvas.update_attributes(name: params[:name])
      render :json => { :text => params[:name] } 
    else
      render :json => { :text => 'fail' } 
    end 
  end 

  def destroy
    Canvas.find(params[:id]).delete 
    @canvas_count = Canvas.all.count
    render :json => { :text => 'ok', :count => @canvas_count } 
  end 

end
