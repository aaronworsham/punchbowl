class FacebooksController < ApplicationController
  
  before_filter :find_post, :only => [:auth, :post_message]

  def auth
    if @post and @post.posted_to_facebook? 
      redirect_to facebook.authorize_url(redirect_uri)
    elsif @post.nil?
      raise "Could not located the post for Facebook Auth"
    elsif !@post.posted_to_facebook?
      raise "Post does not have facebook listed in post_to but was sent to FacebookController"
    end
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error "Params : #{params.inspect}"
    
    flash[:warning] = "Something has happened while trying to authenticate your Facebook account.  Please try again."
      
    if @post
      render 'punchbowl/index'
    else
      render 'facebook/error'
    end
  end

  def post_message
    @customer = @post.customer
    fba =  @customer.facebook_account
    if fba.present? and fba.valid?

      #Post to the wall of a known facebook id using valid token
      response = fba.post_to_wall(@post)

    elsif params[:code]

      #We need to get the token and the users facebook id
      id, token = facebook.verify(params[:code], redirect_uri)
      #Then we need to record the id and token with the customer
      fba = FacebookAccount.create(:customer => @customer, :facebook_id => id, :token => token)
      #finally we need to post to the /me/feed 
      fba.post_to_my_wall(@post)

    else
      raise "We are missing the session code from facebook to retrieve token"
    end

    
    #chain on to Twitter if requested    
    if @post.posted_to_twitter?
      redirect_to auth_post_twitter_path(@post)
    else
      redirect_to '/success'
    end
  rescue => e

    Rails.logger.error e.message
        
    if e.respond_to?("response")
      #TODO uncomment once we get an smtp server set
      #SystemMailer.warning_email(e.response.body).deliver
      Rails.logger.error e.response.body 
      Rails.logger.error e.response.headers
      flash[:warning] =  FacebookApi.handle_error(e.response.body)
    #in the event of an error, we clear out the token.
      @customer.facebook_account.update_attribute(:token, nil) if FacebookApi.token_error?(e.response.body) and @customer.facebook_account.present?
    else
      #TODO uncomment once we get an smtp server set
      #SystemMailer.warning_email(e.message).deliver
      flash[:warning] =  FacebookApi.handle_error(e.message)
    end

    if @post
      render 'punchbowl/index'
    else
      render 'facebook/error'
    end
  end


private
  def facebook
   FacebookApi 
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_facebook_url(@post) 
  end
  
end
