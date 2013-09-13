class RenameFeedToContentInFeeds < ActiveRecord::Migration
  def change
    rename_column :feeds, :feed, :content
  end
end
