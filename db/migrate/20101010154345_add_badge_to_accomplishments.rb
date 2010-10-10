class AddBadgeToAccomplishments < ActiveRecord::Migration
  def self.up
    add_column    :accomplishments,   :badge_id,    :integer
  end

  def self.down
    remove_column   :accomplishements, :badge_id
  end
end
