class CustomerSegmentsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @customer_segment = @canvas.customer_segments.create(content: params[:toSent])
    if @customer_segment.valid?
      render json: { text: @customer_segment.id, color: @customer_segment.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @customer_segment = CustomerSegment.find(params[:id])
    @customer_segment.tag_color = params[:style]
    if @customer_segment.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    CustomerSegment.find(params[:id]).delete()
    render json: { text: 'success' }
  end

end
