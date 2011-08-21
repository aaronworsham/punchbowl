require 'spec_helper'

describe FacebookAccount do

  before(:all) do
    @a = Factory :greenlit_facebook_account

  end
  it 'should be green lit when token and id are present' do
    @a.greenlit?.should be_true
    @a.token.present?.should be_true
    @a.facebook_id.present?.should be_true
  end

  it 'should not be greenlit when token is missing' do
    @a.token = nil
    @a.greenlit?.should be_false
  end

  it 'should not be greenlit when facebook id is missing' do
    @a.facebook_id = nil
    @a.greenlit?.should be_false
  end
end
