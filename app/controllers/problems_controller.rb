class ProblemsController < ApplicationController

  def create 
    @canvas = Canvas.find(params[:canvas_id])
    @problem = @canvas.problems.create(content: params[:toSent])
    if @problem.valid?
      render json: { text: params[:toSent] } 
    else
      render json: { text: 'fail' } 
    end 
  end 

end
