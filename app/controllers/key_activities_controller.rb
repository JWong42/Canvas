class KeyActivitiesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_activity = @canvas.key_activities.create(content: params[:toSent])
    if @key_activity.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end



end
