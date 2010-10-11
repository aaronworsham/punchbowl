class AddBadgesToModels < ActiveRecord::Migration
  def self.up
    add_column    :gift_of_mangos,    :badge_id,    :integer
    add_column    :mango_tangos,    :badge_id,    :integer
  end

  def self.down
    remove_column :gift_of_mangos, :badge_id
    remove_column :mango_tangos, :badge_id

  end
end
