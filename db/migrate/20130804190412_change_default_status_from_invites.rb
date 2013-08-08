class ChangeDefaultStatusFromInvites < ActiveRecord::Migration
  def change
    change_column_default :invites, :status, 'Invite Pending'
  end
end
