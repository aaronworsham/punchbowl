class AddWherePostedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts,  :posted_to_facebook, :boolean, :default => :false
    add_column :posts,  :posted_to_twitter, :boolean, :default => :false
  end

  def self.down
    remove_column :posts, :posted_to_facebook
    remove_column :posts, :posted_to_twitter
  end
end
