class AddToCustomers < ActiveRecord::Migration
  def self.up
    add_column    :customers,   :wants_to_share,    :boolean,   :default => true
    add_column    :customers,   :wants_to_be_asked, :boolean,   :default => false
    add_column    :customers,   :twitter_user,      :boolean,   :default => false
    add_column    :customers,   :facebook_user,     :boolean,   :default => false
  end

  def self.down
    remove_column    :customers,   :wants_to_share
    remove_column    :customers,   :wants_to_be_asked
    remove_column    :customers,   :twitter_user
    remove_column    :customers,   :facebook_user
  end
end
