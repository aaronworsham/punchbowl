class TwittersController < ApplicationController

  respond_to :html, :json

  def auth_success

    @customer = Customer.find_by_id(params[:id])
    ta =  @customer.twitter_account
    if params[:oauth_verifier]

      #Verify the oauth verifier and return a auth token and secret
      token, secret = twitter.verify(twitter_request_token, twitter_request_secret, params[:oauth_verifier])

      #save token and secret to the account
      TwitterAccount.create(:customer => @customer, :token => token, :secret => secret)

    else
      raise "We are missing the session code from facebook to retrieve token"
    end
 
  rescue => e
    flash[:warning] = e.message
    render :json => {:error => true}
  end

private

  def twitter
    TwitterApi.new
  end

  def twitter_request_token
    twitter.client.request_token.token
  end

  def twitter_request_secret
    twitter.client.request_token.secret
  end

  def client
    settings = AppConfig.twitter
    @twitter ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_twitter_url(@post, :from_auth => "true") 
  end

end
