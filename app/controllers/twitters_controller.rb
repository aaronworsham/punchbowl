class TwittersController < ApplicationController

  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    if @post and twitter_post?
      client.set_callback_url(redirect_uri)
      session['rtoken']  = client.request_token.token
      session['rsecret'] = client.request_token.secret
      redirect_to client.request_token.authorize_url
    elsif @post.nil?
      raise "We could not locate the post referenced in the post_id"
    elsif !twitter_post?
      raise "This request does not have a post_for for Twitter"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Post to param = #{params[:post_to]}"
  end

  def post_message
    client.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    twitter = Twitter::Base.new(client)
    twitter.verify_credentials
    twitter.update(@post.message)
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

  def find_post
    @post = Post.find_by_id params[post_id]
  end

  def redirect_uri
    post_message_post_twitter_url(@post, :post_to => paramify_post_to) 
  end

end
