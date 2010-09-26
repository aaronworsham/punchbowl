class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account

#HACK
  def ensure_twitter_account
    self.twitter_account = TwitterAccount.new if self.twitter_account.nil?
  end
end
