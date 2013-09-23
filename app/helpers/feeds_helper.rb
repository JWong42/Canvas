module FeedsHelper

  def get_notifications(user)
    @user = user
    unless @user.nil?
      associations = @user.associations
      canvases_id = associations.map(&:canvas_id)
      @notifications = Feed.where(canvas_id: canvases_id).where.not(user_id: @user.id).order("created_at DESC").limit(20)
      # another way same query as above
      # @notifications = Feed.where("canvas_id IN (?) AND user_id != ?", canvases_id, @user.id).order("created_at DESC").limit(20)
    end
  end 
end
