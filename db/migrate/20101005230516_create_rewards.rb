class CreateRewards < ActiveRecord::Migration
  def self.up
    create_table :rewards do |t|
      t.integer :customer_id
      t.datetime :issued_at
      t.datetime :redeemed_at
      t.string :token
      t.references :rewardable, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :rewards
  end
end
