require 'faker'

Factory.define :facebook_account do |f|
end

Factory.define :greenlit_facebook_account, :parent => :facebook_account do |f|
  f.token 'abcdef'
  f.facebook_id '12345'
end

