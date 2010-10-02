class AddLanguageToAccomp < ActiveRecord::Migration
  def self.up
    add_column  :accomplishments,   :language_id,   :integer
  end

  def self.down
    remove_column :accomplishments,  :language_id
  end
end
