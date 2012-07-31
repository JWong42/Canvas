class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :user_id 
      t.integer :canvas_id 

      t.timestamps
    end

    add_index :ownerships, :user_id 
    add_index :ownerships, :canvas_id 
    add_index :ownerships, [:user_id, :canvas_id], unique: true
  end
end
