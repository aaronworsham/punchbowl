class Customer < ActiveRecord::Base
  has_many :posts
  has_one :twitter_account, :order => 'created_at DESC'
  has_one :facebook_account, :order => 'created_at DESC'

  scope :test, where(:test_account => true)

  validates_uniqueness_of :uuid
  validates_presence_of :uuid

  state_machine :facebook_auth_state, :initial => :unauthorized, :namespace => 'facebook' do
    event :start_authorizing do
      transition :unauthorized => :authorizing
    end

    event :finish_authorizing do
      transition :authorizing => :authorized
    end

    event :fail_to_authorize do
      transition [:authorizing, :unauthorized] => :auth_failure
    end

    event :deauthorize do
      transition all => :unauthorized
    end
  end

  state_machine :twitter_auth_state, :initial => :unauthorized, :namespace => 'twitter' do
    event :start_authorizing do
      transition :unauthorized => :authorizing
    end

    event :finish_authorizing do
      transition :authorizing => :authorized
    end

    event :fail_to_authorize do
      transition [:authorizing, :unauthorized] => :auth_failure
    end

    event :deauthorize do
      transition all => :unauthorized
    end
  end

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
