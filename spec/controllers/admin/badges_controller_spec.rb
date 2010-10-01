require 'spec_helper'

describe Admin::BadgesController do

  def mock_badge(stubs={})
    @mock_badge ||= mock_model(Admin::Badge, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all admin_badges as @admin_badges" do
      Admin::Badge.stub(:all) { [mock_badge] }
      get :index
      assigns(:admin_badges).should eq([mock_badge])
    end
  end

  describe "GET show" do
    it "assigns the requested badge as @badge" do
      Admin::Badge.stub(:find).with("37") { mock_badge }
      get :show, :id => "37"
      assigns(:badge).should be(mock_badge)
    end
  end

  describe "GET new" do
    it "assigns a new badge as @badge" do
      Admin::Badge.stub(:new) { mock_badge }
      get :new
      assigns(:badge).should be(mock_badge)
    end
  end

  describe "GET edit" do
    it "assigns the requested badge as @badge" do
      Admin::Badge.stub(:find).with("37") { mock_badge }
      get :edit, :id => "37"
      assigns(:badge).should be(mock_badge)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created badge as @badge" do
        Admin::Badge.stub(:new).with({'these' => 'params'}) { mock_badge(:save => true) }
        post :create, :badge => {'these' => 'params'}
        assigns(:badge).should be(mock_badge)
      end

      it "redirects to the created badge" do
        Admin::Badge.stub(:new) { mock_badge(:save => true) }
        post :create, :badge => {}
        response.should redirect_to(admin_badge_url(mock_badge))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved badge as @badge" do
        Admin::Badge.stub(:new).with({'these' => 'params'}) { mock_badge(:save => false) }
        post :create, :badge => {'these' => 'params'}
        assigns(:badge).should be(mock_badge)
      end

      it "re-renders the 'new' template" do
        Admin::Badge.stub(:new) { mock_badge(:save => false) }
        post :create, :badge => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested badge" do
        Admin::Badge.should_receive(:find).with("37") { mock_badge }
        mock_admin_badge.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :badge => {'these' => 'params'}
      end

      it "assigns the requested badge as @badge" do
        Admin::Badge.stub(:find) { mock_badge(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:badge).should be(mock_badge)
      end

      it "redirects to the badge" do
        Admin::Badge.stub(:find) { mock_badge(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_badge_url(mock_badge))
      end
    end

    describe "with invalid params" do
      it "assigns the badge as @badge" do
        Admin::Badge.stub(:find) { mock_badge(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:badge).should be(mock_badge)
      end

      it "re-renders the 'edit' template" do
        Admin::Badge.stub(:find) { mock_badge(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested badge" do
      Admin::Badge.should_receive(:find).with("37") { mock_badge }
      mock_admin_badge.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_badges list" do
      Admin::Badge.stub(:find) { mock_badge }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_badges_url)
    end
  end

end
