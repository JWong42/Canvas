class UniqueValuePropositionsController < ApplicationController

  def create
    @canvas = Canvas.find(params[:canvas_id])
    @unique_value_proposition = @canvas.unique_value_propositions.create(content: params[:toSent])
    if @unique_value_proposition.valid?
      content = "#{current_user.first_name} #{current_user.last_name} created a new item in the 'unique value proposition' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'unique_value_propositions', item_id: @unique_value_proposition.id, item_content: @unique_value_proposition.content, item_color: @unique_value_proposition.tag_color, notification: content, emails: results["emails"], type: 'item-create' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render json: { text: @unique_value_proposition.id, color: @unique_value_proposition.tag_color }
    else
      render json: { text: 'fail' }
    end
  end

  def update
    @unique_value_proposition = UniqueValueProposition.find(params[:id])
    @unique_value_proposition.tag_color = params[:style]
    @canvas = Canvas.find(@unique_value_proposition.canvas_id)
    if @unique_value_proposition.save
      content = "#{current_user.first_name} #{current_user.last_name} changed the label of an item in the 'unique value propositions' component of #{@canvas.name} canvas."
      results = handle_feed(content, @canvas, current_user)
      data = { canvas_id: @canvas.id, component: 'unique_value_propositions', item_id: @unique_value_proposition.id, item_color: @unique_value_proposition.tag_color, notification: content, emails: results["emails"], type: 'item-update' }.to_json
      redis = Redis.new
      redis.publish('feeds', data)
      render :json => { :text => 'success' }
    else
      render :json => { :text => 'fail' }
    end 
  end 

  def destroy
    @unique_value_proposition = UniqueValueProposition.find(params[:id])
    @canvas = Canvas.find(@unique_value_proposition.canvas_id)
    content = "#{current_user.first_name} #{current_user.last_name} deleted an item in the 'unique value propositions' component of #{@canvas.name} canvas."
    results = handle_feed(content, @canvas, current_user)
    data = { canvas_id: @canvas.id, component: 'unique_value_propositions', item_id: @unique_value_proposition.id, notification: content, emails: results["emails"], type: 'item-delete' }.to_json
    redis = Redis.new
    redis.publish('feeds', data)
    @unique_value_proposition.destroy
    render json: { text: 'success' }
  end

end
