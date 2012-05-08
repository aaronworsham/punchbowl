class UpdateForDevise < ActiveRecord::Migration
  class Users < ActiveRecord::Base
  end

  def up
    #change_table :users do |u|
    #  u.remove :remember_token
    #  u.column :reset_password_sent_at, :datetime
    #end
    #User.reset_column_information
    #say "downcasing User#emails"
    #User.all.each do |user|
    #  user.update_attribute!(:email, user.read_attribute(:email).downcase)
    #end
  end

  def down
    #change_table :users do |u|
    #  u.column :remember_token, :string
    #  u.remove :reset_password_sent_at
    #end
  end
end
