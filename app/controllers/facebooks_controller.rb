class FacebooksController < ApplicationController
  
  before_filter :find_post, :only => [:auth, :post_message]
  before_filter :setup_post_to

  def auth
    if @post and facebook_post? 
      redirect_to client.web_server.authorize_url(
        :redirect_uri => redirect_uri, 
        :scope => 'email,publish_stream,offline_access'
      )
    elsif @post.nil?
      raise "Could not located the post for Facebook Auth"
    elsif !facebook_post?
      raise "Post does not have facebook listed in post_to but was sent to FacebookController"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Params : #{params.inspect}"
    flash[:warning] = "Something unusual has happened so we have notified the administrators.  We are very sorry for this."
      if @post
      render 'punchbowl/index'
    else
      render 'facebook/error'
    end
  end

  def post_message
    customer = @post.customer
    if customer.facebook_token.present? and customer.facebook_id.present?
      access_token = OAuth2::AccessToken.new(client, customer.facebook_token)
      Rails.logger.info "Has Token: #{customer.facebook_token}"
      response = JSON.parse(access_token.post("/#{customer.facebook_id}/feed", :message => @post.message))  
    else
      access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri) 
      Rails.logger.info "Needed Token: #{access_token.token}"
      response = JSON.parse(access_token.get("/me")) 
      customer.update_attributes(:facebook_token => access_token.token, :facebook_id => response["id"])
    end
    render :text => response.inspect


    # #chain on to Twitter if requested    
    # if twitter_post?
    #   redirect_to auth_post_twitter_path(@post, :post_to => paramify_post_to)
    # else
    #   redirect_to '/success'
    # end
  rescue => e
    Rails.logger.error e.message
    if e.respond_to?("response")
      Rails.logger.error e.response.body 
      Rails.logger.error e.response.headers
      message = if e.response.present? 
        "Message from Facebook: #{JSON.parse(e.response.body)["error"]["message"]}"
      else 
        e.message
      end
      flash[:warning] = message
    else
      flash[:warning] = e.message
    end
    # if @post
    #   render 'punchbowl/index'
    # else
    #   render 'facebook/error'
    # end
  end


private
  def client
    settings = AppConfig.facebook
    OAuth2::Client.new(settings["key"], settings["secret"], :site => 'https://graph.facebook.com')
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_facebook_url(@post, :post_to => paramify_post_to) 
  end
  
end
