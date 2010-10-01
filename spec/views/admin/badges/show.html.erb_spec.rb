require 'spec_helper'

describe "admin_badges/show.html.erb" do
  before(:each) do
    @badge = assign(:badge, stub_model(Admin::Badge))
  end

  it "renders attributes in <p>" do
    render
  end
end
