class RevenueStreamsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @revenue_stream = @canvas.revenue_streams.create(content: params[:toSent])
    if @revenue_stream.valid?
      render json: { text: @revenue_stream.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy 
    RevenueStream.find(params[:id]).delete()
    render json: { text: 'success' } 
  end 

end
