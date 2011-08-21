require 'faker'

Factory.define :post do |f|
  f.message "test"
  f.association :customer
end

Factory.define :facebook_post, :parent => :post do |f|
  f.posted_to_facebook true
end

Factory.define :twitter_post, :parent => :post do |f|
  f.posted_to_twitter true
end

Factory.define :facebook_and_twitter_post, :parent => :post do |f|
  f.posted_to_facebook true
  f.posted_to_twitter true
end
