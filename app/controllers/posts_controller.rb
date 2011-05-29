class PostsController < ApplicationController
  include PostableMixin
  
  before_filter :check_auth_key, :only => [:create]

  def new
    @email = params[:email]
    @source = params[:source] || ""
    @post = params[:source] ? Post.new(:postable_type => params[:source].classify) : Post.new
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


end
