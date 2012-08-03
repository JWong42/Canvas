class CanvasesController < ApplicationController

  def new 
  end 

  def create
    @canvas = current_user.canvases.create(params[:canvas])
    if @canvas.valid? 
      render :json => { :name => @canvas.name } 
    else
      render :json => { :name => 'fail' } 
    end 
  end 

end
