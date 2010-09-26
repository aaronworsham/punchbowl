class TwittersController < ApplicationController

  before_filter :parse_post_to, :only => [:auth, :post_message]

  def auth
    if twitter_post?
      client.set_callback_url(redirect_uri)
      session['rtoken']  = client.request_token.token
      session['rsecret'] = client.request_token.secret
      redirect_to client.request_token.authorize_url
    else
      raise "Without a post_to for twitter, you should not be in this action"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Post to param = #{params[:post_to]}"
  end

  def post_message
    client.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    post = Post.last
    twitter = Twitter::Base.new(client)
    twitter.verify_credentials
    twitter.update(post.message)
    redirect_to "/success"
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error response.inspect
  end

private

  def client
    settings = AppConfig.twitter
    @twitter ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/twitter/post_message'
    uri.query = paramify_post_to
    uri.to_s
  end

end
