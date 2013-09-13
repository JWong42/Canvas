class CreateUnreadFeeds < ActiveRecord::Migration
  def change
    create_table :unread_feeds do |t|
      t.integer :user_id
      t.integer :count, default: 0
      t.integer :list, array: true, default: []

      t.timestamps
    end
  end
end
