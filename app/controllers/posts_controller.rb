class PostsController < ApplicationController
  include PostableMixin
  

  def new
    @test_customers = Customer.test
    @post =  Post.new
  end

  def create
    @customer = Customer.find_by_uuid(params[:uuid])
    @post = Post.create(params[:post].merge(:customer => @customer)) if @customer
    if @customer and @post
      post_to_social_media
    else
      raise 'Missing customer or post'
    end
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info params.inspect
    render :json => {:error => e.message}
  end

  def index
    if params[:customer_id]
      @posts = Post.where(:customer_id => params[:customer_id])
    elsif params[:uuid]
      customer = Customer.find_by_uuid(params[:uuid])
      @posts = Post.where(:customer_id => customer.id)
    else
      @posts = Post.all
    end
    render :json => @posts
  end


end
