class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed
      t.integer :user_id
      t.integer :canvas_id

      t.timestamps
    end
  end
end
