class AddFacebookIdToPost < ActiveRecord::Migration
  def self.up
    add_column  :posts,   :facebook_id,   :string
    add_column  :posts,   :twitter_id,   :string

  end

  def self.down
    remove_column   :posts,   :facebook_id
    remove_column   :posts,   :twitter_id
  end
end
