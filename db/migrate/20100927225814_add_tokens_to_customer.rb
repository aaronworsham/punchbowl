class AddTokensToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers,  :facebook_token, :string
    add_column :customers,  :twitter_token, :string
  end

  def self.down
    remove_column :customers, :facebook_token
    remove_column :customers, :twitter_token

  end
end
