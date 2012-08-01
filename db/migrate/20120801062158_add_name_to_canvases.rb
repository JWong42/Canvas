class AddNameToCanvases < ActiveRecord::Migration
  def change
    add_column :canvases, :name, :string 
  end
end
