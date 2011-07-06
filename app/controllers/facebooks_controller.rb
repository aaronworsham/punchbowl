class FacebooksController < ApplicationController
  
  respond_to :html, :json


  def auth_success
    @customer = Customer.find_by_id(params[:customer_id])
          #We need to get the token and the users facebook id
    id, token = facebook.verify(params[:code], auth_success_customer_facebook_url(@customer))
    Rails.logger.info "Id = :#{id} Token = :#{token}"
    #Then we need to record the id and token with the customer
    Rails.logger.info "creating account"
    FacebookAccount.create(:facebook_id => id, :token => token, :customer => @customer) if @customer
    if @customer and @customer.twitter_user? and !@customer.twitter_green_lit?
      redirect_to TwitterApi.new(@customer).authorize_url(auth_success_customer_twitter_url(@customer))
    else
      render :json => {:success => true, :facebook => 'authorized'}
    end
  rescue => e
    Rails.logger.error e.message
    render :json => {:error => e.message}
  end


private
  def facebook
   @facebook ||= FacebookApi.new
  end
  
end
