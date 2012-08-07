class UniqueValuePropositionsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unique_value_proposition = @canvas.unique_value_propositions.create(content: params[:toSent])
    if @unique_value_proposition.valid?
      render json: { text: @unique_value_proposition.id, color: @unique_value_proposition.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @unique_value_proposition = UniqueValueProposition.find(params[:id])
    @unique_value_proposition.tag_color = params[:style]
    if @unique_value_proposition.save
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 


  def destroy
    UniqueValueProposition.find(params[:id]).delete()
    render json: { text: 'success' }
  end


end
