class AddStatesToCustomer < ActiveRecord::Migration
  def self.up
    add_column :customers, :facebook_auth_state, :string
    add_column :customers, :twitter_auth_state, :string
  end

  def self.down
    remove_column :customers, :facebook_auth_state
    remove_column :customers, :twitter_auth_state
  end
end
