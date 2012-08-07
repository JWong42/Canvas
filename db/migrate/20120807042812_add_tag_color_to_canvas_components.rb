class AddTagColorToCanvasComponents < ActiveRecord::Migration
  def change
    add_column :problems, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :channels, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :cost_structures, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :customer_segments, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :key_activities, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :key_metrics, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :revenue_streams, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :unfair_advantages, :tag_color, :text, null: false, default: '#3ba1bf'
    add_column :unique_value_propositions, :tag_color, :text, null: false, default: '#3ba1bf'
  end
end
