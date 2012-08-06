class CostStructuresController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @cost_structure = @canvas.cost_structures.create(content: params[:toSent])
    if @cost_structure.valid?
      render json: { text: params[:toSent] }
    else
      render json: { text: 'fail' }
    end
  end

end
