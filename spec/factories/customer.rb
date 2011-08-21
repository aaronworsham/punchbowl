require 'faker'

Factory.define :customer do |f|
  f.name Faker::Name.name
  f.email Faker::Internet.email
  f.uuid rand(10000)
  f.wants_to_share true
  f.wants_to_be_asked false
end

Factory.define :facebook_customer, :parent => :customer do |f|
  f.facebook_user true
  f.association :facebook_account
end
Factory.define :greenlit_facebook_customer, :parent => :customer do |f|
  f.facebook_user true
  f.association :facebook_account, :factory => :greenlit_facebook_account
end
Factory.define :twitter_customer, :parent => :customer do |f|
  f.twitter_user true
  f.association :twitter_account
end
Factory.define :greenlit_twitter_customer, :parent => :customer do |f|
  f.twitter_user true
  f.association :twitter_account, :factory => :greenlit_twitter_account
end

Factory.define :facebook_and_twitter_customer, :parent => :customer do |f|
  f.twitter_user true
  f.facebook_user true
  f.association :facebook_account
  f.association :twitter_account
end
Factory.define :greenlit_facebook_and_twitter_customer, :parent => :customer do |f|
  f.twitter_user true
  f.facebook_user true
  f.association :facebook_account, :factory => :greenlit_facebook_account
  f.association :twitter_account, :factory => :greenlit_twitter_account
end
