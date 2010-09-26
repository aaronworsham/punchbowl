class ChangeUserNameToEmail < ActiveRecord::Migration

  def self.up
    rename_column  :customers, :name, :email
  end

  def self.down
    rename_column  :customers, :email, :name
  end

end
