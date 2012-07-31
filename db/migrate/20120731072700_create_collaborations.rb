class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.integer :user_id 
      t.integer :collaborator_id 

      t.timestamps
    end
      
      add_index :collaborations, :user_id 
      add_index :collaborations, :collaborator_id 
      add_index :collaborations, [:user_id, :collaborator_id], unique: true 

  end
end
