class FacebooksController < ApplicationController
  
  respond_to :html, :json


  def auth_success
    @customer = Customer.find_by_id(params[:id])
          #We need to get the token and the users facebook id
    id, token = facebook.verify(params[:code], redirect_uri)
    Rails.logger.info "Id = :#{id} Token = :#{token}"
    #Then we need to record the id and token with the customer
    Rails.logger.info "creating account"
    @customer.facebook_account.create(:facebook_id => id, :token => token) if @customer
    if @customer and @customer.twitter_user?
      redirect_to TwitterApi.new.authorize_url(auth_success_customer_twitter_url(@customer))
    end
  rescue => e
    flash[:warning] = e.message
    render :json => {:error => e.message}
  end


private
  def facebook
   @facebook ||= FacebookApi.new
  end

  def find_post
    @post ||= Post.find_by_id params[:post_id]
  end

  def redirect_uri
    post_message_post_facebook_url(@post, :from_auth => "true") 
  end
  
end
