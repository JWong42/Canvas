class RemoveNameFromInvites < ActiveRecord::Migration
  def up
    remove_column :invites, :name, :string
  end

  def down
    add_column :invites, :name, :string
  end
end
