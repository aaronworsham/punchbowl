class PostsController < ApplicationController
  include PostableMixin
  respond_to :html, :json
  layout 'post'
  def new
    @email = params[:email]
    @source = params[:source] || ""
    @post = params[:source] ? Post.new(:postable_type => params[:source].classify) : Post.new
    render :layout => 'message'
  end
  def create
    @source = params[:source] || ""
    if email.present?
      @customer = Customer.find_or_create_by_email(:email => email)
    elsif uuid.present?
      @customer = Customer.find_or_create_by_uuid(:uuid => uuid)
    else
      raise "Cannot locate User without an email or uuid"
    end
    if params[:post] 
      @post = Post.create(params[:post].merge(:customer => @customer, :postable_type => @source.classify))
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
    if params[:from] == "lightbox"
      render :template => 'posts/success_for_lightbox', :layout => 'message'
    else
      render :layout => 'post'
    end
  end

  def error
    render :layout => 'message'
  end
 
 private
  def email
    params[:post][:email] || session[:email]    
  end

  def uuid
    params[:post][:uuid] || session[:uuid]
  end 

end
