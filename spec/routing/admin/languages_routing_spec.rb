require "spec_helper"

describe Admin::LanguagesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin_languages" }.should route_to(:controller => "admin_languages", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_languages/new" }.should route_to(:controller => "admin_languages", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_languages/1" }.should route_to(:controller => "admin_languages", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_languages/1/edit" }.should route_to(:controller => "admin_languages", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_languages" }.should route_to(:controller => "admin_languages", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin_languages/1" }.should route_to(:controller => "admin_languages", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_languages/1" }.should route_to(:controller => "admin_languages", :action => "destroy", :id => "1")
    end

  end
end
