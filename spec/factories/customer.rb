require 'faker'

FactoryGirl.define do
  factory :customer do
    name Faker::Name.name
    email Faker::Internet.email
    uuid Random.rand(10000)
    wants_to_share true
    wants_to_be_asked false
  end

  factory :facebook_customer, :parent => :customer do
    facebook_user true
    association :facebook_account
  end

  factory :greenlit_facebook_customer, :parent => :customer do
    facebook_user true
    association :facebook_account, :factory => :greenlit_facebook_account
  end

  factory :twitter_customer, :parent => :customer do
    twitter_user true
    association :twitter_account
  end

  factory :twitter_test_user, :parent => :customer do
    twitter_user true
    association :twitter_account, :factory => :twitter_test_account
    name 'sazboom_test'
    email 'aaron+twittertest@sazboom.com'
    uuid 'aaron+twittertest@sazboom.com'

  end

  factory :greenlit_twitter_customer, :parent => :customer do
    twitter_user true
    association :twitter_account, :factory => :greenlit_twitter_account
  end

  factory :facebook_and_twitter_customer, :parent => :customer do
    twitter_user true
    facebook_user true
    association :facebook_account
    association :twitter_account
  end

  factory :greenlit_facebook_and_twitter_customer, :parent => :customer do
    twitter_user true
    facebook_user true
    association :facebook_account, :factory => :greenlit_facebook_account
    association :twitter_account, :factory => :greenlit_twitter_account
  end
end
