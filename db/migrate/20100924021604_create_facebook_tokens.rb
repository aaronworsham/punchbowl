class CreateFacebookTokens < ActiveRecord::Migration
  def self.up
    create_table :facebook_tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_tokens
  end
end
