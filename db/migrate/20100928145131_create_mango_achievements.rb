class CreateMangoAchievements < ActiveRecord::Migration
  def self.up
    create_table :mango_achievements do |t|
      t.integer :badge_id
      t.integer :post_id
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mango_achievements
  end
end
