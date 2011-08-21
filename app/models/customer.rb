class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account, :order => 'created_at DESC'
  has_one :facebook_account, :order => 'created_at DESC'

  scope :test, where(:test_account => true)

  validates_uniqueness_of :uuid
  validates_presence_of :uuid

  def facebook_greenlit?
    !!(facebook_account && facebook_account.greenlit?)
  end

  def twitter_greenlit?
    !!(twitter_account && twitter_account.greenlit?)
  end

  def greenlit?
    facebook_greenlit? and twitter_greenlit?
  end
end
