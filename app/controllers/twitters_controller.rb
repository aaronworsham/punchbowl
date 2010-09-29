class TwittersController < ApplicationController

  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    if @post and @post.posted_to_twitter?
      url, session[:twitter_request_token], session[:twitter_request_secret] = twitter.authorize_url(redirect_uri)
      redirect_to url
    elsif @post.nil?
      raise "Could not located the post for Facebook Auth"
    elsif !@post.posted_to_twitter?
      raise "Post does not have twitter listed in post_to but was sent to TwitterController"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Params = #{params.inspect}"
    flash[:warning] = "Something has happened while trying to authenticate your Twitter account.  Please try again."
    if @post
      render @post.update_template
    else
      render 'twitter/error'
    end
    
  end

  def post_message

    @customer = @post.customer
    ta =  @customer.twitter_account
    if ta.present? and ta.green_light?

      #Post to the wall of a known facebook id using valid token
      ta.post(@post)

    elsif params[:oauth_verifier]

      #Verify the oauth verifier and return a auth token and secret
      token, secret = twitter.verify(session[:twitter_request_token], session[:twitter_request_secret], params[:oauth_verifier])

      #save token and secret to the account
      ta = TwitterAccount.create(:customer => @customer, :token => token, :secret => secret)

      #finally we need to post to the twitter account
      ta.post(@post.message)

    else
      raise "We are missing the session code from facebook to retrieve token"
    end

    respond_to do |wants|
      wants.html { redirect_to @post.success_url }
      wants.json { render :json => {:success => true, :message => "Success"} }
    end


  rescue => e
    Rails.logger.error e.message
        
    if e.respond_to?("response")
      #TODO uncomment once we get an smtp server set
      #SystemMailer.warning_email(e.response.body).deliver
      Rails.logger.error e.response.inspect
      Rails.logger.error e.response.headers
    #in the event of an error, we clear out the token.
      @customer.twitter_account.update_attribute(:token, nil) if TwitterApi.token_error?(e.response) and @customer.twitter_account.present?
      @customer.update_attribute(:last_error, e.response) 
      render :json => FacebookApi.handle_error(e.response) 
    else
      #TODO uncomment once we get an smtp server set
      #SystemMailer.warning_email(e.message).deliver
      @customer.update_attribute(:last_error, e.message) 
      render :json => e.message.to_json    
    end
   end

private

  def twitter
    TwitterApi
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
