class RemovePostAndBadgeIdFromAccomp < ActiveRecord::Migration
  def self.up
    remove_column   :accomplishments,   :post_id
    remove_column   :accomplishments,   :badge_id
  end

  def self.down
    add_column   :accomplishments,   :post_id   , :integer
    add_column   :accomplishments,   :badge_id,   :integer

  end
end
