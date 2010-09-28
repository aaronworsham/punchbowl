class AddCustomerIdToFacebookAccount < ActiveRecord::Migration
  def self.up
    add_column :facebook_accounts,  :customer_id, :integer
  end

  def self.down
    remove_column :facebook_accounts, :customer_id
  end
end
