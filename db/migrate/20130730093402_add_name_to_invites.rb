class AddNameToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :name, :string
  end
end
