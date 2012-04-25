require 'faker'

FactoryGirl.define  do

  factory :greenlit_twitter_account, :parent => :twitter_account do
    token 'abcdef'
    secret '12345'
  end

  factory :twitter_test_account, :parent => :twitter_account do
    secret AppConfig.twitter["test_secret"]
    token AppConfig.twitter["test_token"]
  end

end

