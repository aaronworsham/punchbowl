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
    Rails.logger.info client.access_token_url
    Rails.logger.info client.web_server.access_token_params(session[:code], :redirect_uri => redirect_uri).to_json
    access_token = client.web_server.get_access_token(session[:code], :redirect_uri => redirect_uri) 
    # p = Post.last
    response = JSON.parse(access_token.get('/me')) 
    render :text => response.inspect
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.response.body
    Rails.logger.error e.response.headers
  end


private
  def client
    OAuth2::Client.new('154629021224817', '48ad712fe340e5e13aaa015bc721a272', :site => 'https://graph.facebook.com')
  end


  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/facebook/post_message'
    uri.query = nil
    uri.to_s
  end
  
end
