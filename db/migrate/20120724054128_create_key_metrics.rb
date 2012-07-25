class CreateKeyMetrics < ActiveRecord::Migration
  def change
    create_table :key_metrics do |t|
      t.string :content 
      t.timestamps
    end
  end
end
