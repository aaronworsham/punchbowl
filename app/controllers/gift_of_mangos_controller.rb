class GiftOfMangosController < ApplicationController
  layout 'gift_of_mango'
  include PostableMixin
  
  respond_to :html, :json
  
  def new
    @post = Post.new(:postable_type => "GiftOfMango" )
  end

  
  def create
    email= params[:post].delete(:email)
    @customer = Customer.find_or_create_by_email(:email => email)
    @post = Post.create(params[:post].merge(:customer => @customer))
    GiftOfMango.create(:post => @post, :customer => @customer)
    post_to_social_media
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info params.inspect
    flash[:warning] = e.message 
    render :template => 'posts/error', :layout => 'message'
  end

  def update
    @post = Post.find params[:id]
    @customer = @post.customer
    post_to_social_media
  end

  private
  
end
