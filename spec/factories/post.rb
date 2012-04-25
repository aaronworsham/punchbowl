require 'faker'

FactoryGirl.define  do

  factory :post do
    message "test"
    association :customer
  end

  factory :facebook_post, :parent => :post do
    posted_to_facebook true
  end

  factory :twitter_post, :parent => :post do
    posted_to_twitter true
  end

  factory :facebook_and_twitter_post, :parent => :post do
    posted_to_facebook true
    posted_to_twitter true
  end

end
