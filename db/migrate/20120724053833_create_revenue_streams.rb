class CreateRevenueStreams < ActiveRecord::Migration
  def change
    create_table :revenue_streams do |t|
      t.string :content
      t.timestamps
    end
  end
end
