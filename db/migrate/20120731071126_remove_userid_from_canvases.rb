class RemoveUseridFromCanvases < ActiveRecord::Migration
  def up
    remove_column :canvases, :user_id
  end

  def down
    add_column :canvases, :user_id, :integer 
  end
end
