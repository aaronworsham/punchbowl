class TwittersController < ApplicationController

  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    render :text => "Email not provided", :status => 401 if email.nil?
    if @post and twitter_post?
      redirect_to twitter.get_authorize_url(redirect_uri) 
    elsif @post.nil?
      raise "We could not locate the post referenced in the post_id"
    elsif !twitter_post?
      raise "This request does not have a post_for for Twitter"
    end
  end

  def post_message
    twitter.authorize(params[:oauth_verifier])
    twitter.post(@post.message)
    redirect_to "/success"
  end

private

  def twitter
    current_customer.ensure_twitter_account
    current_customer.twitter_account
  end

  def client
    settings = AppConfig.twitter
    @twitter ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_twitter_url(@post, :post_to => paramify_post_to) 
  end

end
