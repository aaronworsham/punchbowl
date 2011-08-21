require 'spec_helper'

describe TwitterAccount do
  before(:all) do
    @a = Factory :greenlit_twitter_account

  end
  it 'should be green lit when token and id are present' do
    @a.greenlit?.should be_true
    @a.token.present?.should be_true
    @a.secret.present?.should be_true
  end

  it 'should not be greenlit when token is missing' do
    @a.token = nil
    @a.greenlit?.should be_false
  end

  it 'should not be greenlit when secret is missing' do
    @a.secret = nil
    @a.greenlit?.should be_false
  end



end
