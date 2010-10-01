require "spec_helper"

describe Admin::BadgesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin_badges" }.should route_to(:controller => "admin_badges", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_badges/new" }.should route_to(:controller => "admin_badges", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_badges/1" }.should route_to(:controller => "admin_badges", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_badges/1/edit" }.should route_to(:controller => "admin_badges", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_badges" }.should route_to(:controller => "admin_badges", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin_badges/1" }.should route_to(:controller => "admin_badges", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_badges/1" }.should route_to(:controller => "admin_badges", :action => "destroy", :id => "1")
    end

  end
end
