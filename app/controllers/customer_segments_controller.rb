class CustomerSegmentsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @customer_segment = @canvas.customer_segments.create(content: params[:toSent])
    if @customer_segment.valid?
      render json: { text: @customer_segment.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    CustomerSegment.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
