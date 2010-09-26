class TwittersController < ApplicationController

  before_filter :find_post, :only => [:auth, :post_message]
  before_filter :setup_post_to

  def auth
    #render :text => "Email not provided", :status => 401 if email.nil?
    if @post and twitter_post?
      client.set_callback_url(redirect_uri)
      session['rtoken']  = client.request_token.token
      session['rsecret'] = client.request_token.secret
      redirect_to client.request_token.authorize_url
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
    client.authorize_from_request(session['rtoken'], session['rsecret'], params[:oauth_verifier])
    twitter = Twitter::Base.new(client)
    twitter.verify_credentials
    twitter.update(@post.message)
    redirect_to "/success"
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.reponse.inspect
    # Rails.logger.error e.response.body 
    # Rails.logger.error e.response.headers
    # if e.respond_to?("response")
    #   message = if e.response.present? 
    #     "Message from Twitter: #{JSON.parse(e.response.body)["error"]["message"]}"
    #   else 
    #     e.message
    #   end
    #   flash[:warning] = message
    # else
    #   flash[:warning] = e.message
    # end
    # if @post
    #   render 'punchbowl/index'
    # else
    #   render 'twitter/error'
    # end
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

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_twitter_url(@post, :post_to => paramify_post_to) 
  end

end
