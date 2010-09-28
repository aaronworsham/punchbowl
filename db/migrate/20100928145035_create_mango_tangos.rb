class CreateMangoTangos < ActiveRecord::Migration
  def self.up
    create_table :mango_tangos do |t|
      t.integer :post_id
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mango_tangos
  end
end
