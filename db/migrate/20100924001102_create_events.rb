class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :facebook_events do |t|
      t.integer :user_id

      t.timestamps
    end
    create_table :twitter_events do |t|
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_events
    drop_table :facebook_events
  end
end
