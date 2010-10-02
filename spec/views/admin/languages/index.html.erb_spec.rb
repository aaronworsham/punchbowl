require 'spec_helper'

describe "admin_languages/index.html.erb" do
  before(:each) do
    assign(:admin_languages, [
      stub_model(Admin::Language),
      stub_model(Admin::Language)
    ])
  end

  it "renders a list of admin_languages" do
    render
  end
end
