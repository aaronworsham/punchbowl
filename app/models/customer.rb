class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account, :order => 'created_at DESC'
  has_one :facebook_account, :order => 'created_at DESC'
  has_many :gifts, :class_name => "GiftOfMango"
  has_many :rewards

  scope :test, where(:test_account => true)

  validates_uniqueness_of :uuid
  validates_presence_of :uuid

#HACK
  def ensure_twitter_account
    self.twitter_account = TwitterAccount.new if self.twitter_account.nil?
  end
  
  def facebook_green_lit?
    !!(facebook_account && facebook_account.green_light?)
  end

  def twitter_green_lit?
    !!(twitter_account && twitter_account.green_light?)
  end

  def green_lit?
    facebook_green_li? and twitter_green_lit?
  end
end
