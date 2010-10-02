require 'spec_helper'

describe "admin_languages/show.html.erb" do
  before(:each) do
    @language = assign(:language, stub_model(Admin::Language))
  end

  it "renders attributes in <p>" do
    render
  end
end
