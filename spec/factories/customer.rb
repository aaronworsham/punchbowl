require 'faker'

Factory.define :customer do |f|
  f.name Faker::Name.name
  f.email Faker::Internet.email
  f.uuid rand(10000)
  f.wants_to_share true
  f.wants_to_be_asked false
  f.twitter_user true
  f.facebook_user true
  f.association :facebook_account
end
