class ProblemsController < ApplicationController

  def create 
    @canvas = Canvas.find(params[:canvas_id])
    @problem = @canvas.problems.create(content: params[:toSent])
    if @problem.valid?
      render json: { text: @problem.id, color: @problem.tag_color } 
    else
      render json: { text: 'fail' } 
    end 
  end 

  def update 
    @problem = Problem.find(params[:id])
    @problem.tag_color = params[:style]
    if @problem.save 
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    Problem.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
