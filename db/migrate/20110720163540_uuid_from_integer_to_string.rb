class UuidFromIntegerToString < ActiveRecord::Migration
  def self.up
    change_column   :customers,  :uuid,   :string
  end

  def self.down
    change_column  :customers, :uuid,  :integer
  end
end
