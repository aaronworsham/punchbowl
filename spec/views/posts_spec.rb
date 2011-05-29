require 'spec_helper'
include Capybara::DSL
describe "Post Views", :type => :request do

  it "visits the home page" do
    visit('/')
    page.should have_selector('#new_post')
  end

  context :test_ajax do
    before(:each) do
      FacebookAccount.any_instance.stubs(:post_to_wall).returns(true)
      @session = Capybara::Session.new(:rack_test, Punchbowl::Application) 
      @session.visit('/')
    end

    it "passes to authenticate when user is unknown by email" do
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in 'UUID', :with => 5
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['error'].should eq('Missing customer or post')
    end

    it "posts to facebook when user is known and permissioned to post to facebook" do
      @user = Factory :customer, :uuid => 5
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => 5
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['status'].should eq('tested')

    end
  end
end
