class AddNameToDancePartners < ActiveRecord::Migration
  def self.up
    add_column    :dance_partners,    :name,    :string
  end

  def self.down
    remove_column   :dance_partners,  :name
  end
end
