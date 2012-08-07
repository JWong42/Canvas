class ProblemsController < ApplicationController

  def create 
    @canvas = Canvas.find(params[:canvas_id])
    @problem = @canvas.problems.create(content: params[:toSent])
    if @problem.valid?
      render json: { text: @problem.id } 
    else
      render json: { text: 'fail' } 
    end 
  end 

  def destroy
    Problem.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
