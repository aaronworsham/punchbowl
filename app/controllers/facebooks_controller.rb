class FacebooksController < ApplicationController
  
  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    if @post and facebook_post? 
      redirect_to client.web_server.authorize_url(
        :redirect_uri => redirect_uri, 
        :scope => 'email,publish_stream,offline_access'
      )
    elsif @post.nil?
      raise "We could not locate the post referenced in the post_id"
    elsif !facebook_post?
      raise "This request does not have a post_for for Facebook"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Post to param = #{params[:post_to]}"
  end

  def post_message
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri) 
        response = JSON.parse(access_token.post('/me/feed', :message => @post.message)) 
    
    #chain on to Twitter if requested    
    if twitter_post?
      redirect_to auth_twitter_post(post, :post_to => paramify_post_to)
    else
      render :text => response.inspect
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.response.body
    Rails.logger.error e.response.headers
  end


private
  def client
    settings = AppConfig.facebook
    OAuth2::Client.new(settings["key"], settings["secret"], :site => 'https://graph.facebook.com')
  end

  def find_post
    @post = Post.find_by_id params[post_id]
  end

  def redirect_uri
    post_message_facebook_post_path(@post, :post_to => paramify_post_to) 
  end
  
end
