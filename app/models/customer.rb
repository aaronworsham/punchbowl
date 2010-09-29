class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account
  has_one :facebook_account
  has_many :gifts, :class_name => "GiftOfMango"

#HACK
  def ensure_twitter_account
    self.twitter_account = TwitterAccount.new if self.twitter_account.nil?
  end
end
