require 'spec_helper'

describe FacebookApi do

  before(:all) do
    @user, @fba = TestFacebookApi.new.add_test_user
    @message = "test random #{rand(1000000)}"

  end
  after(:all) do
    @fba.delete_test_user(@user)
  end

  context :test_user do

    it "should not be nil" do
      @user.should_not be_nil
    end

    it "should not have a nil id" do
      @user["id"].should_not be_nil
    end

  end

  context :facebook_api do
    it "should not be nil" do
      @fba.should_not be_nil
    end
  
    it "should have same token as user" do
      @fba.access_token.should eq(@user["access_token"])
    end
  end

  context :basic_info do
    it "should be able to get basic info on user" do
      info = @fba.profile(@user["id"])
      info["id"].should eq(@user["id"])
    end
  end

  context :publishing do
    it "should be able to post to the users wall" do
      resp = @fba.post_to_wall(@user["id"], @message)
      resp["id"].should_not be_nil
    end

    it "should be able to read from the wall (intermittent failures)" do
      sleep 10
      resp =  @fba.read_from_wall(@user["id"])
      resp["data"][0]["message"].should eq(@message)
    end
  end


end
