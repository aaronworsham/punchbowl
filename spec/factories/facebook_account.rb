require 'faker'

FactoryGirl.define :facebook_account do
  factory :facebook_account do
  end

  factory :greenlit_facebook_account, :parent => :facebook_account do
    token 'abcdef'
    facebook_id '12345'
  end
end

