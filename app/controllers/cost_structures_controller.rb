class CostStructuresController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @cost_structure = @canvas.cost_structures.create(content: params[:toSent])
    if @cost_structure.valid?
      render json: { text: @cost_structure.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    CostStructure.find(params[:id]).delete()
    render json: { text: 'success' }
  end 

end
