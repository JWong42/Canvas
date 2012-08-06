class CustomerSegmentsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @customer_segment = @canvas.customer_segments.create(content: params[:toSent])
    if @customer_segment.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end



end
