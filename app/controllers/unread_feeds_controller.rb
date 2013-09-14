class UnreadFeedsController < ApplicationController
  def update
    id = params[:id]
    unread_feed = UnreadFeed.where(user_id: id).first
    unread_feed.update_attributes!(user_id: id, count: 0, list: [])
    render nothing: true
  end
end
