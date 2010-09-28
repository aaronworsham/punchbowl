class CreateFacebookAccounts < ActiveRecord::Migration
  def self.up
    create_table :facebook_accounts do |t|

      t.string        :facebook_id
      t.string        :token
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_accounts
  end
end
