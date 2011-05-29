require 'faker'

Factory.define :facebook_account do |f|
  f.facebook_id rand 10000
  f.token rand 1000
end

