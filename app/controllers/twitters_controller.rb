class TwittersController < ApplicationController

  def auth
    render :text => "Email not provided", :status => 401 if email.nil?
    session[:post] = params[:post]
    client.set_callback_url(redirect_uri)
    session['rtoken']  = client.request_token.token
    session['rsecret'] = client.request_token.secret
    redirect_to client.request_token.authorize_url
  end

  def post_message
    client.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    post = Post.create(session[:post])
    twitter = Twitter::Base.new(client)
    twitter.verify_credentials
    twitter.update(post.message)
    render :text => response.inspect
  end

private

  def email
    session[:email] ||= params[:email]
  end

  def customer 
    Customer.find_by_email email
  end

  def client
    settings = AppConfig.twitter
    @twitter ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/twitter/post_message'
    uri.query = nil
    uri.to_s
  end

end
