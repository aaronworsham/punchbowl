class AddCustomerToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :customer_id, :integer
  end

  def self.down
    remove_column :posts, :customer_id
  end
end
