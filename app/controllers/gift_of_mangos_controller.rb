class GiftOfMangosController < ApplicationController
  layout 'gift_of_mango'
  include PostableMixin
  def new
    @post = Post.new
  end

  
  def create
    self.email= params[:post].delete(:email)
    @customer = Customer.find_or_create_by_email(:email => email)
    @post = Post.create(params[:post].merge(:customer => @customer))
    GiftOfMango.create(:post => @post, :customer => @customer)
    post_to_social_media
  end

  def update
    @post = Post.find params[:id]
    @customer = @post.customer
    post_to_social_media
  end

  private
  
end
