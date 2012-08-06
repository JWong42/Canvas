class KeyMetricsController < ApplicationController

   def create
    @canvas = Canvas.find(params[:canvas_id])
    @key_metric = @canvas.key_metrics.create(content: params[:toSent])
    if @key_metric.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end

end
