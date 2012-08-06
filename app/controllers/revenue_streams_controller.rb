class RevenueStreamsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @revenue_stream = @canvas.revenue_streams.create(content: params[:toSent])
    if @revenue_stream.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end



end
