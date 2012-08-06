class ChannelsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @channel = @canvas.channels.create(content: params[:toSent])
    if @channel.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end

end
