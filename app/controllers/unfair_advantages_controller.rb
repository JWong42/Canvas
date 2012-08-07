class UnfairAdvantagesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unfair_advantage = @canvas.unfair_advantages.create(content: params[:toSent])
    if @unfair_advantage.valid?
      render json: { text: @unfair_advantage.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    UnfairAdvantage.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
