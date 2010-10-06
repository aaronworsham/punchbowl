class CreateAppStats < ActiveRecord::Migration
  def self.up
    create_table :app_stats do |t|
      t.integer :tango_reward_week

      t.timestamps
    end
  end

  def self.down
    drop_table :app_stats
  end
end
