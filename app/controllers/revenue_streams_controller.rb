class RevenueStreamsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @revenue_stream = @canvas.revenue_streams.create(content: params[:toSent])
    if @revenue_stream.valid?
      render json: { text: @revenue_stream.id, color: @revenue_stream.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @revenue_stream = RevenueStream.find(params[:id])
    @revenue_stream.tag_color = params[:style]
    if @revenue_stream.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy 
    RevenueStream.find(params[:id]).delete()
    render json: { text: 'success' } 
  end 

end
