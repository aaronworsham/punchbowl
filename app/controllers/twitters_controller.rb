class TwittersController < ApplicationController

  before_filter :find_post, :only => [:auth, :post_message]
  before_filter :setup_post_to

  def auth
    render :text => "Email not provided", :status => 401 if email.nil?
    if @post and twitter_post?
      redirect_to twitter.get_authorize_url(redirect_uri) 
    elsif @post.nil?
      raise "Could not located the post for Facebook Auth"
    elsif !twitter_post?
      raise "Post does not have facebook listed in post_to but was sent to TwitterController"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Post to param = #{params[:post_to]}"
    flash[:warning] = "Something unusual has happened so we have notified the administrators.  We are very sorry for this."
      if @post
      render 'punchbowl/index'
    else
      render 'twitter/error'
    end
  end

  def post_message
    twitter.authorize(params[:oauth_verifier])
    twitter.post(@post.message)
    redirect_to "/success"
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.reponse.inspect
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
