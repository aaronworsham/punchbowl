require 'spec_helper'

describe TwitterAccount do

  it "can be persisted" do 
    t = TwitterAccount.make
    t.save.should == true
    t.id.should > 0
  end

  describe "#has_credentials?" do 
    it "is false if secret, token or verifier dont exist" do 
      account = TwitterAccount.make      
      account.token = nil
      account.has_credentials?.should == false
    end

    it "is true when secret, token and verifier exist" do 
      account = TwitterAccount.make      
      account.has_credentials?.should == true
    end
  end


end
