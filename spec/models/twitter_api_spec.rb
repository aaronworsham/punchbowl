require 'spec_helper'

describe TwitterApi do

  before(:all) do
    @message = "test random #{rand(1000000)}"
  end

  before(:each) do
    @user = Customer.find_by_name AppConfig.twitter["test_name"]
    @ta = @user.twitter_account
  end

  context :test_user do
    it "should not be nil - if it is you need to setup the Twiiter Test User manually!" do
      @user.should_not be_nil
    end
  end

  context :twitter_account do
    it "should not be nil" do
      @ta.should_not be_nil
    end
  
    it "should have a token" do
      @ta.token.should_not be_nil
    end

    it "should have a secret" do
      @ta.secret.should_not be_nil
    end

    it "should be greenlit" do
      @ta.greenlit?.should be true
    end
  end

  context :publishing do
    it "should be able to post to the users timeline" do
      @ta.post(Factory( :post, :message => @message)).should eq 'success'
    end

    it "should be able to read from the wall (intermittent failures)" do
      sleep(10)
      resp =  @ta.last_post
      resp["text"].should eq(@message)
    end
  end


end

