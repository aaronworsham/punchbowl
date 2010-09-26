class FacebooksController < ApplicationController
  
  def index

  end
  def auth
    if facebook_post?
      redirect_to client.web_server.authorize_url(
        :redirect_uri => redirect_uri, 
        :scope => 'email,publish_stream,offline_access'
      )
    else
      raise "Without a post_to for facebook, you should not be in this action"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Post to param = #{params[:post_to]}"
  end

  def post_message
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri) 
    p = Post.last
    response = JSON.parse(access_token.post('/me/feed', :message => p.message)) 
    if post_to.include?("twitter")
      redirect_to "/twitter/auth?#{paramify_post_to}"
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


  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/facebook/post_message'
    uri.query = paramify_post_to 
    uri.to_s
  end
  
end
