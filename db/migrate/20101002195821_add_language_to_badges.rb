class AddLanguageToBadges < ActiveRecord::Migration
  def self.up
    add_column  :badges,    :language_id,   :integer
  end

  def self.down
    remove_column   :badges,    :language_id
  end
end
