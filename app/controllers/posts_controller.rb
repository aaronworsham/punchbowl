class PostsController < ApplicationController
  include PostableMixin
  respond_to :html, :json
  layout 'application'
  def new
    @post = Post.new
    @source = params[:source]
    render :layout => 'post'
  end
  def create
    if email.present?
      @customer = Customer.find_or_create_by_email(:email => email)
    elsif uuid.present?
      @customer = Customer.find_or_create_by_uuid(:uuid => uuid)
    else
      raise "Cannot locate User without an email or uuid"
    end
    if params[:post] 
      @post = Post.create(params[:post].merge(:customer => @customer))
    else
      raise "Missing :post param"
    end
    post_to_social_media
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info params.inspect
    render :template => 'posts/error'
  end

  def success

  end
  

end
