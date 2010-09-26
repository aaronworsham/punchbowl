class FacebooksController < ApplicationController
  
  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    if @post and facebook_post? 
      redirect_to client.web_server.authorize_url(
        :redirect_uri => redirect_uri, 
        :scope => 'email,publish_stream,offline_access'
      )
    elsif @post.nil?
      raise "Could not located the post for Facebook Auth"
    elsif !facebook_post?
      raise "Post does not have facebook listed in post_to but was sent to FacebookController"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Params : #{params.inspect}"
    flash[:warning] = "Something unusual has happened so we have notified the administrators.  We are very sorry for this."
      if @post
      render 'punchbowl/index'
    else
      render 'facebook/error'
    end
  end

  def post_message
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri) 
    response = JSON.parse(access_token.post('/me/feed', :message => @post.message)) 
    
    #chain on to Twitter if requested    
    if twitter_post?
      redirect_to auth_post_twitter_path(@post, :post_to => paramify_post_to)
    else
      render :text => response.inspect
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.response.body 
    Rails.logger.error e.response.headers
    if e.respond_to?("response") 
      flash[:warning] = e.response.present? ? JSON.parse(e.response)["error"]["message"] : e.message
    else
      flash[:warning] = e.message
    end
    if @post
      render 'punchbowl/index'
    else
      render 'facebook/error'
    end
  end


private
  def client
    settings = AppConfig.facebook
    OAuth2::Client.new(settings["key"], settings["secret"], :site => 'https://graph.facebook.com')
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_facebook_url(@post, :post_to => paramify_post_to) 
  end
  
end
