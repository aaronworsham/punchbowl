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
      TwitterAccount.any_instance.stubs(:post).returns(true)
      @session = Capybara::Session.new(:rack_test, Punchbowl::Application) 
      @session.visit('/')
    end

    it "passes to authenticate when user is unknown by email" do
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in 'UUID', :with => 5
        @session.check 'post_posted_to_facebook'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_false
      response['error'].should eq('Missing customer or post')
    end

    it "fails to select social network" do
      @user = FactoryGirl.create :greenlit_facebook_customer
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => @user.uuid
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_false
      response['error'].should eq('Please select a supported Network, IE Facebook or Twitter')
    end

    it "should not post if neither facebook or twitter user" do
      @user = FactoryGirl.create :customer, :uuid => 5
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => 5
        @session.check 'post_posted_to_facebook'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_false
      response['error'].should eq('Customer not a Facebook User')

    end
    it "posts to facebook when user is known and permissioned to post to facebook" do
      @user = FactoryGirl.create :facebook_customer
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => @user.uuid
        @session.check 'post_posted_to_facebook'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_false
      response['error'].should eq('Customer not authorized to Facebook')

    end
    it "posts to twitter when user is known and permissioned to post to twitter" do
      @user = FactoryGirl.create :twitter_customer
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => @user.uuid
        @session.check 'post_posted_to_twitter'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_false
      response['error'].should eq('Customer not authorized to Twitter')

    end

    it "posts to facebook when user is known and permissioned to post to facebook" do
      @user = FactoryGirl.create :greenlit_facebook_customer
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => @user.uuid
        @session.check 'post_posted_to_facebook'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_true

    end
    it "posts to twitter when user is known and permissioned to post to twitter" do
      @user = FactoryGirl.create :greenlit_twitter_customer
      @user.save
      @session.within('#new_post') do
        @session.fill_in 'Message', :with => 'bob'
        @session.fill_in  'UUID', :with => @user.uuid
        @session.check 'post_posted_to_twitter'
        @session.click_on("Deliver")
      end
      response = JSON.parse(@session.source)
      response['success'].should be_true

    end

  end
end
