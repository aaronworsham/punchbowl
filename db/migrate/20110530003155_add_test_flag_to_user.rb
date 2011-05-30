class AddTestFlagToUser < ActiveRecord::Migration
  def self.up
    add_column :customers, :test_account, :boolean,  :default => false
  end

  def self.down
    remove_column :customers, :test_account
  end
end
