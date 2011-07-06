require 'spec_helper'

describe TwitterAccount do

  it "can be persisted" do 
    t = TwitterAccount.make
    t.save.should == true
    t.id.should > 0
  end




end
