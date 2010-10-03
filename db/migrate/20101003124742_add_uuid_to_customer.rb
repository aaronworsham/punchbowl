class AddUuidToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers,  :uuid,  :integer
    add_index :customers, :uuid
    add_index :customers, :email
  end


  def self.down
    remove_column :customers,   :uuid
    remove_index  :customers,   :uuid
    remove_index  :customers,   :email 
  end
end
