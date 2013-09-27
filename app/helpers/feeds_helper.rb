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

  def handle_feed(content, canvas, current_user, invite_email=nil)
    # save current_user's feed to database
    feed = Feed.create!(content: content, user_id: current_user.id, canvas_id: canvas.id)
    users = canvas.users.where.not(email: current_user.email)
    # if the feed is for sent invite, check if potential collaborator already registered an account
    invited_user = User.where(email: invite_email).first
    invites_count = nil
    # if an account is present, take necessary actions
    unless invited_user.blank?
      users << invited_user
      Association.create!(user_id: invited_user.id, canvas_id: canvas.id)
      invites_count = Invite.where(email: invited_user.email, status: 'Invite Pending').count 
    end 
    emails = users.map(&:email) 
    emails = emails.to_set
    # add current_user's feed as an unread feed for collaborators
    users.each do |user| 
      if user.unread_feed.nil?
        UnreadFeed.create!(user_id: user.id, count: 1, list: [feed.id])
      else
        unread_feed = user.unread_feed
        unread_feed_count = unread_feed.count + 1
        unread_feed_list = unread_feed.list + [feed.id]
        unread_feed.update_attributes!(user_id: user.id, count: unread_feed_count, list: unread_feed_list)
      end
    end
    # return results so that redis can push out feed update to relevant users
    results = { "emails" => emails, "invited_user_id" => invited_user.blank? ? nil : invited_user.id, "invites_count" => invites_count } 
  end
end
