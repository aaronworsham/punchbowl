class TwittersController < ApplicationController

  respond_to :html, :json

  def auth_success
    @customer = Customer.find_by_id(params[:customer_id])
    if params[:oauth_verifier]
      #Verify the oauth verifier and return a auth token and secret
      access_token = twitter.verify(params[:oauth_verifier])
      #save token and secret to the account
      TwitterAccount.create(:customer => @customer, :token => access_token.token, :secret => access_token.secret)
      @customer.finish_authorizing_twitter
      @network = 'Twitter'
      render :template => 'shared/close_window'

    else
      @customer.fail_to_authorize_twitter
      raise "We are missing the session code from facebook to retrieve token"
    end
  rescue => e
    @customer.fail_to_authorize_twitter if @customer
    Rails.logger.error e.message
    @network = 'Twitter'
    render :template => 'shared/close_window'
  end

private

  def twitter
    if @customer
      @twitter ||= TwitterApi.new(@customer)
    else
      raise 'Missing customer in Twitter API call'
    end
  end


end
