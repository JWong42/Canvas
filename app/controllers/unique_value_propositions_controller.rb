class UniqueValuePropositionsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unique_value_proposition = @canvas.unique_value_propositions.create(content: params[:toSent])
    if @unique_value_proposition.valid?
      render json: { text: @unique_value_proposition.id }
    else
      render json: { text: 'fail' }
    end
  end

  def destroy
    UniqueValueProposition.find(params[:id]).delete()
    render json: { text: 'success' }
  end


end
