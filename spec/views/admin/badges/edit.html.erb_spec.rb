require 'spec_helper'

describe "admin_badges/edit.html.erb" do
  before(:each) do
    @badge = assign(:badge, stub_model(Admin::Badge,
      :new_record? => false
    ))
  end

  it "renders the edit badge form" do
    render

    rendered.should have_selector("form", :action => badge_path(@badge), :method => "post") do |form|
    end
  end
end
