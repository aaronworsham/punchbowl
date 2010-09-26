class FacebooksController < ApplicationController
  def index

  end
  def auth
    Post.create(params[:post]) #This needs to be keyed to an email or user id
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri, 
      :scope => 'email,publish_stream,offline_access'
    )
  end

  def post_message
    Rails.logger.info Rails.env
    Rails.logger.info AppConfig.facebook["key"]
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri) 
    p = Post.last
    response = JSON.parse(access_token.post('/me/feed', :message => p.message)) 
    render :text => response.inspect
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
    uri.query = nil
    uri.to_s
  end
  
end
