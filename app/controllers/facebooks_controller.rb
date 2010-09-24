class FacebooksController < ApplicationController
  def index

  end
  def auth
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri, 
      :scope => 'email,publish_stream'
    )
  
  end
  def get_code
    @post = Post.new
    session[:code] = params[:code]
    render 'message'
  end
  def post_message
    fe = FacebookEvent.create
    p = Post.create(params[:post].merge(:postable => fe))
    access_token = client.web_server.get_access_token(session[:code], :redirect_uri => redirect_uri)
    response = JSON.parse(access_token.post('/me/feed', {:message=> p.message}))
    render :text => response.inspect
  end


private
  def client
    OAuth2::Client.new('154629021224817', '48ad712fe340e5e13aaa015bc721a272', :site => 'https://graph.facebook.com')
  end


  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/facebook/get_code'
    uri.query = nil
    uri.to_s
  end
  
end
