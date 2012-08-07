class KeyActivitiesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_activity = @canvas.key_activities.create(content: params[:toSent])
    if @key_activity.valid?
      render json: { text: @key_activity.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    KeyActivity.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
