class AlterPostMessage < ActiveRecord::Migration
  def self.up
    change_column :posts, :message, :text
  end

  def self.down
    change_column :posts, :message, :string
  end
end
