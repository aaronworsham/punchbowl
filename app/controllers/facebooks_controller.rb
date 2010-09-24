class FacebooksController < ApplicationController
  layout 'applicaiton'
  def index

  end
  def auth
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri, 
      :scope => 'email,offline_access'
    )
  
  end
  def check
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/me'))
    render :text => user.inspect
  end
  def feed
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    response = JSON.parse(access_token.post('/me/feed', :message=> 'hi'))
    render :text => response.inspect
  end


private
  def client
    OAuth2::Client.new('154629021224817', '48ad712fe340e5e13aaa015bc721a272', :site => 'https://graph.facebook.com')
  end


  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/facebook/feed'
    uri.query = nil
    uri.to_s
  end
  
end
