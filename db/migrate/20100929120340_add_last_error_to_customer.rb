class AddLastErrorToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers,  :last_error,  :text
  end

  def self.down
    remove_column  :customers, :last_error
  end
end
