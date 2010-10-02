require 'spec_helper'

describe "admin_languages/edit.html.erb" do
  before(:each) do
    @language = assign(:language, stub_model(Admin::Language,
      :new_record? => false
    ))
  end

  it "renders the edit language form" do
    render

    rendered.should have_selector("form", :action => language_path(@language), :method => "post") do |form|
    end
  end
end
