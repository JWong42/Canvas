class KeyActivitiesController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_activity = @canvas.key_activities.create(content: params[:toSent])
    if @key_activity.valid?
      render json: { text: @key_activity.id, color: @key_activity.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @key_activity = KeyActivity.find(params[:id])
    @key_activity.tag_color = params[:style]
    if @key_activity.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    KeyActivity.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
