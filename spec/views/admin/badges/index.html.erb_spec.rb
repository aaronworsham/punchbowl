require 'spec_helper'

describe "admin_badges/index.html.erb" do
  before(:each) do
    assign(:admin_badges, [
      stub_model(Admin::Badge),
      stub_model(Admin::Badge)
    ])
  end

  it "renders a list of admin_badges" do
    render
  end
end
