class CreateKeyActivities < ActiveRecord::Migration
  def change
    create_table :key_activities do |t|
      t.string :content
      t.timestamps
    end
  end
end
