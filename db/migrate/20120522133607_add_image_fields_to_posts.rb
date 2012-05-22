class AddImageFieldsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :image_src, :string
    add_column :posts, :image_url, :string
  end

  def self.down
    remove_column  :posts,  :image_src
    remove_column  :posts,  :image_url
  end
end


