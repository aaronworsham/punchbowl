require 'spec_helper'

describe TwitterAccount do

  it "can be persisted" do 
    t = TwitterAccount.make
    t.save.should == true
    t.id.should > 0
  end

#   describe "#has_credentials?" do 
#     it "is false if secret, token or verifier dont exist" do 
#       account = TwitterAccount.make      
#       account.token = nil
#       account.has_credentials?.should == false
#     end
# 
#     it "is true when secret, token and verifier exist" do 
#       account = TwitterAccount.make      
#       account.has_credentials?.should == true
#     end
#   end
# 
#   describe "@set_callback_url" do 
# 
#     let(:account) {TwitterAccount.new}
# 
#     before(:each) do 
#       account.expects(:save)
#       account.get_authorize_url("http://aol.com")
#      end
# 
#     it "creates a token and key" do 
#       account.token.should_not be_nil
#       account.secret.should_not be_nil
#     end

  # end

  describe "#verify" do

    let(:account) {TwitterAccount.new}

    describe "when invalid" do

      before(:each) do
#account.expects(:save).never
#        @result = account.verify(:token)
      end

      # todo: save expectation is in the before
      it "returns false and doesn't save the account" do
       pending 
#        @result.should == false
      end

    end

    describe "when valid" do

      before(:each) do 
#        account.expects(:save)
#@result = account.verify(:token)
      end
      
      # todo: save expectation is in the before
      it "returns true and saves the account" do
        pending
#@result.should == true
      end
    end 
  end

end
