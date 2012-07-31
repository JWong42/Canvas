class AddUseridToCanvases < ActiveRecord::Migration
  def change
    add_column :canvases, :user_id, :integer
  end
end
