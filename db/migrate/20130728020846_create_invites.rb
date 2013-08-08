class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :canvas_id
      t.string :name
      t.string :email
      t.string :status, :default => 'pending'

      t.timestamps
    end
  end
end
