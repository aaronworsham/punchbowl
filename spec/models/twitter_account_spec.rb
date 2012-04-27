require 'spec_helper'

describe TwitterAccount do
  subject { FactoryGirl.create :greenlit_twitter_account }

  it 'should be green lit when token and id are present' do
    subject.should be_greenlit
    subject.token.should be_present
    subject.secret.should be_present
  end

  it 'should not be greenlit when token is missing' do
    subject.token = nil
    subject.should_not be_greenlit
  end

  it 'should not be greenlit when secret is missing' do
    subject.secret = nil
    subject.should_not be_greenlit
  end



end
