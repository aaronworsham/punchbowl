class AddTokensToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers,  :facebook_token, :string
    add_column :customers,  :facebook_id, :string
    add_column :customers,  :twitter_token, :string
    add_column :customers,  :twitter_id, :string

  end

  def self.down
    remove_column :customers, :facebook_token
    remove_column :customers, :twitter_token
    remove_column :customers, :facebook_id
    remove_column :customers, :twitter_id

  end
end
