require 'spec_helper'

describe "admin_languages/new.html.erb" do
  before(:each) do
    assign(:language, stub_model(Admin::Language,
      :new_record? => true
    ))
  end

  it "renders new language form" do
    render

    rendered.should have_selector("form", :action => admin_languages_path, :method => "post") do |form|
    end
  end
end
