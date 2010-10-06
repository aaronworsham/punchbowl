class AddAddressToRewards < ActiveRecord::Migration
  def self.up
    add_column :rewards,    :street_address,    :string
    add_column :rewards,    :city,              :string
    add_column :rewards,    :state_or_province, :string
    add_column :rewards,    :postal_code,       :string
    add_column :rewards,    :country,           :string
  end

  def self.down
   remove_column :rewards,    :street_address    
   remove_column :rewards,    :city              
   remove_column :rewards,    :state_or_province 
   remove_column :rewards,    :postal_code       
   remove_column :rewards,    :country           
  end
end
