class CreateAccomplishments < ActiveRecord::Migration
  def self.up
    create_table :accomplishments do |t|
      t.integer :customer_id
      t.integer :badge_id
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :accomplishments
  end
end