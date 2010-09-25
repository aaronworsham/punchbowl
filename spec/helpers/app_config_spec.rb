require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')
describe "AppConfig" do

  it "has settings" do 
    AppConfig.email.should == "yeah@test.com"
  end

  it "has child hashes" do 
    AppConfig.something[ "somethingelse"].should == "yeah"
  end

end

