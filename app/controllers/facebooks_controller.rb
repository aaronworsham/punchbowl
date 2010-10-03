class FacebooksController < ApplicationController
  
  before_filter :find_post, :only => [:auth, :post_message]

  respond_to :html, :json

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
    render "/posts/error"
  end

  def post_message
    @customer = @post.customer
    fba =  @customer.facebook_account
    if fba.present? and fba.green_light?

      #Post to the wall of a known facebook id using valid token
      response = fba.post_to_wall(@post)

    elsif params[:code]
      Rails.logger.info "Post message 1"

      #We need to get the token and the users facebook id
      id, token = facebook.verify(params[:code], redirect_uri)
      Rails.logger.info "Id = :#{id} Token = :#{token}"
      #Then we need to record the id and token with the customer
      Rails.logger.info "creating account"
      fba = FacebookAccount.create(:customer => @customer, :facebook_id => id, :token => token)
      #finally we need to post to the /me/feed 
      Rails.logger.info "posting to wall"
      fba.post_to_my_wall(@post)

    else
      raise "We are missing the session code from facebook to retrieve token"
    end

    respond_to do |wants|
      wants.html {
        if @post.posted_to_twitter? 
          if @customer.twitter_account and @customer.twitter_account.green_light?
            redirect_to post_message_post_twitter_path(@post)
          else
            redirect_to auth_post_twitter_path(@post)
          end
        else
          redirect_to posts_success_path(:from => "auth")
        end
      }
      wants.json { render :json => {:success => true, :message => "Success"}.to_json }
    end

  rescue => e
    flash[:warning] = e.message
    render '/posts/error'
  end


private
  def facebook
   FacebookApi 
  end

  def find_post
    @post = Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_facebook_url(@post, :from_auth => "true") 
  end
  
end
