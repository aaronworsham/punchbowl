class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account, :order => 'created_at DESC'
  has_one :facebook_account, :order => 'created_at DESC'
  has_many :gifts, :class_name => "GiftOfMango"
  has_many :rewards

#HACK
  def ensure_twitter_account
    self.twitter_account = TwitterAccount.new if self.twitter_account.nil?
  end
end
