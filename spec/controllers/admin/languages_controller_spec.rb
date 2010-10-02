require 'spec_helper'

describe Admin::LanguagesController do

  def mock_language(stubs={})
    @mock_language ||= mock_model(Admin::Language, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all admin_languages as @admin_languages" do
      Admin::Language.stub(:all) { [mock_language] }
      get :index
      assigns(:admin_languages).should eq([mock_language])
    end
  end

  describe "GET show" do
    it "assigns the requested language as @language" do
      Admin::Language.stub(:find).with("37") { mock_language }
      get :show, :id => "37"
      assigns(:language).should be(mock_language)
    end
  end

  describe "GET new" do
    it "assigns a new language as @language" do
      Admin::Language.stub(:new) { mock_language }
      get :new
      assigns(:language).should be(mock_language)
    end
  end

  describe "GET edit" do
    it "assigns the requested language as @language" do
      Admin::Language.stub(:find).with("37") { mock_language }
      get :edit, :id => "37"
      assigns(:language).should be(mock_language)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created language as @language" do
        Admin::Language.stub(:new).with({'these' => 'params'}) { mock_language(:save => true) }
        post :create, :language => {'these' => 'params'}
        assigns(:language).should be(mock_language)
      end

      it "redirects to the created language" do
        Admin::Language.stub(:new) { mock_language(:save => true) }
        post :create, :language => {}
        response.should redirect_to(admin_language_url(mock_language))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved language as @language" do
        Admin::Language.stub(:new).with({'these' => 'params'}) { mock_language(:save => false) }
        post :create, :language => {'these' => 'params'}
        assigns(:language).should be(mock_language)
      end

      it "re-renders the 'new' template" do
        Admin::Language.stub(:new) { mock_language(:save => false) }
        post :create, :language => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested language" do
        Admin::Language.should_receive(:find).with("37") { mock_language }
        mock_admin_language.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :language => {'these' => 'params'}
      end

      it "assigns the requested language as @language" do
        Admin::Language.stub(:find) { mock_language(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:language).should be(mock_language)
      end

      it "redirects to the language" do
        Admin::Language.stub(:find) { mock_language(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_language_url(mock_language))
      end
    end

    describe "with invalid params" do
      it "assigns the language as @language" do
        Admin::Language.stub(:find) { mock_language(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:language).should be(mock_language)
      end

      it "re-renders the 'edit' template" do
        Admin::Language.stub(:find) { mock_language(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested language" do
      Admin::Language.should_receive(:find).with("37") { mock_language }
      mock_admin_language.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_languages list" do
      Admin::Language.stub(:find) { mock_language }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_languages_url)
    end
  end

end
