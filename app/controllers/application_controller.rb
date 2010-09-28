class ApplicationController < ActionController::Base
  protect_from_forgery

  def email
    session[:email] ||= params[:email]
  end

  def email=(e)
    session[:email] = e
  end

  def current_customer 
    Customer.find_or_create_by_email email
  end

  def post_to_social_media
    if @post.posted_to_facebook?
      if @customer.facebook_account and @customer.facebook_account.green_light? 
        redirect_to post_message_post_facebook_path(@post)
      else
        redirect_to auth_post_facebook_path(@post)
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_account and @customer.twitter_account.green_light?
        redirect_to post_message_post_twitter_path(@post)
      else
        redirect_to auth_post_twitter_path(@post)
      end
    end
  end


end
