class TwittersController < ApplicationController

  respond_to :html, :json

  def auth_success

    @customer = Customer.find_by_id(params[:id])
    if params[:oauth_verifier]
      #Verify the oauth verifier and return a auth token and secret
      token, secret = twitter.verify(request_token.token, request_token.secret, params[:oauth_verifier])
      #save token and secret to the account
      TwitterAccount.create(:customer => @customer, :token => token, :secret => secret)
      render :js => 'alert("Authorized with Twitter")'
    else
      raise "We are missing the session code from facebook to retrieve token"
    end
 
  rescue => e
    flash[:warning] = e.message
    render :json => {:error => true}
  end

private

  def twitter
    @twitter ||= TwitterApi.new
  end

  def request_token
    @request_token ||= twitter.client.request_token
  end

end
