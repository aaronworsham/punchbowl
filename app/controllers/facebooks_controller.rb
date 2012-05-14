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
    @customer.finish_authorizing_facebook
    if @customer and @customer.twitter_user? and !@customer.twitter_greenlit?
      redirect_to TwitterApi.new(@customer).authorize_url(auth_success_customer_twitter_url(@customer))
    else
      @customer.fail_to_authorize_twitter
      render :json => {:success => true, :facebook => 'authorized'}
    end
  rescue => e
    @customer.fail_to_authorize_twitter if @customer
    Rails.logger.error e.message
    render :json => {:error => e.message}
  end


private
  def facebook
   @facebook ||= FacebookApi.new
  end
end
