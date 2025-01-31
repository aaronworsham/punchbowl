require 'spec_helper'

describe Post do
  it 'should not be posted to facebook or twitter by default' do
    p = FactoryGirl.build :post
    p.facebook?.should be_false
    p.twitter?.should be_false
  end

  it 'should be posted to facebook if selected' do
    p = FactoryGirl.build :facebook_post
    p.facebook?.should be_true
  end

  it 'should be posted to twitter if selected' do
    p = FactoryGirl.build :twitter_post
    p.twitter?.should be_true
  end
end
