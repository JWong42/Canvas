class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :content
      t.timestamps
    end
  end
end
