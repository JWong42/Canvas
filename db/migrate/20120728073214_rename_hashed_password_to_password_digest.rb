class RenameHashedPasswordToPasswordDigest < ActiveRecord::Migration
  def up
    rename_column :users, :hashed_password, :password_digest
  end

  def down
    rename_column :users, :password_digest, :hashed_password
  end
end
