require 'faker'

Factory.define :twitter_account do |f|
end

Factory.define :greenlit_twitter_account, :parent => :twitter_account do |f|
  f.token 'abcdef'
  f.secret '12345'
end

Factory.define :twitter_test_account, :parent => :twitter_account do |f|
  f.secret AppConfig.twitter["test_secret"]
  f.token AppConfig.twitter["test_token"]
end

