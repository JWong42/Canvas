class AddCanvasIdToCanvasComponents < ActiveRecord::Migration
  def change
    add_column :channels, :canvas_id, :integer
    add_column :cost_structures, :canvas_id, :integer
    add_column :customer_segments, :canvas_id, :integer
    add_column :key_activities, :canvas_id, :integer
    add_column :key_metrics, :canvas_id, :integer
    add_column :problems, :canvas_id, :integer
    add_column :revenue_streams, :canvas_id, :integer
    add_column :unfair_advantages, :canvas_id, :integer
    add_column :unique_value_propositions, :canvas_id, :integer
  end
end
