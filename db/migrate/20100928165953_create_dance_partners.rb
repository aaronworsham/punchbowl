class CreateDancePartners < ActiveRecord::Migration
  def self.up
    create_table :dance_partners do |t|
      t.string :email
      t.integer :mango_tango_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dance_partners
  end
end
