class UnfairAdvantagesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unfair_advantage = @canvas.unfair_advantages.create(content: params[:toSent])
    if @unfair_advantage.valid?
      render json: { text: @unfair_advantage.id, color: @unfair_advantage.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @unfair_advantage = UnfairAdvantage.find(params[:id])
    @unfair_advantage.tag_color = params[:style]
    if @unfair_advantage.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    UnfairAdvantage.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
