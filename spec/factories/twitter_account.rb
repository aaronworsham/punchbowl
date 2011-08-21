require 'faker'

Factory.define :twitter_account do |f|
end

Factory.define :greenlit_twitter_account, :parent => :twitter_account do |f|
  f.token 'abcdef'
  f.secret '12345'
end

