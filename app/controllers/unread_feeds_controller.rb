class UnreadFeedsController < ApplicationController
  def update
    id = params[:id]
    unread_feed = UnreadFeed.where(user_id: id)[0]
    unread_feed.update_attributes!(user_id: id, count: 0, list: [])
    render nothing: true
  end
end
