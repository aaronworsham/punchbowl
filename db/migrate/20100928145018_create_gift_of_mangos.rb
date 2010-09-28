class CreateGiftOfMangos < ActiveRecord::Migration
  def self.up
    create_table :gift_of_mangos do |t|
      t.integer :post_id
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gift_of_mangos
  end
end
