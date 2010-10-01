require 'spec_helper'

describe "admin_badges/new.html.erb" do
  before(:each) do
    assign(:badge, stub_model(Admin::Badge,
      :new_record? => true
    ))
  end

  it "renders new badge form" do
    render

    rendered.should have_selector("form", :action => admin_badges_path, :method => "post") do |form|
    end
  end
end
