class ChannelsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @channel = @canvas.channels.create(content: params[:toSent])
    if @channel.valid?
      render json: { text: @channel.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    Channel.find(params[:id]).delete()
    render json: { text: 'success' }
  end
 

end
