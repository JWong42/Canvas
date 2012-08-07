class ChannelsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @channel = @canvas.channels.create(content: params[:toSent])
    if @channel.valid?
      render json: { text: @channel.id, color: @channel.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.tag_color = params[:style]
    if @channel.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    Channel.find(params[:id]).delete()
    render json: { text: 'success' }
  end
 

end
