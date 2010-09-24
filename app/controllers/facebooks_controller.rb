class FacebooksController < ApplicationController
  def index

  end
  def auth
    redirect_to client.web_server.authorize_url(
      :redirect_uri => redirect_uri, 
      :scope => 'email,publish_stream,offline_acess'
    )
  
  end
  def get_code
    @post = Post.new
    access_token = client.web_server.get_access_token(session[:code], :redirect_uri => redirect_uri) 
    FacebookToken.create(
      :access_token => access_token.token,
      :refresh_token => access_token.refresh_token,
      :expires_at => access_token.expires_at
    )
    render 'message'
  end
  def post_message
    p = Post.create(params[:post].merge(:postable => FacebookEvent.create))
    ft = FacebookToken.last #TODO this needs to lookup by a user param in the future
    if ft.expires_at.nil? or ft.expires_at > Time.now
      access_token = OAuth2::AccessToken.new(client, ft.access_token, ft.refresh_token)
    else
      access_token = client.web_server.get_access_token(session[:code], :redirect_uri => redirect_uri) 
      FacebookToken.create(
        :access_token => access_token.token,
        :refresh_token => access_token.refresh_token,
        :expires_at => access_token.expires_at
      )
    end
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
