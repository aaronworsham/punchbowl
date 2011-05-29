class CustomersController < ApplicationController

  before_filter :check_auth_key, :only => [:show]
  respond_to :json, :xml
  def show
    @customer = Customer.find_by_uuid(params[:uuid])
    respond_with @customer do |format|
      format.json{
       if @customer.present? 
        render :json => {
          :existing_user => true, 
          :facebook => {
            :opt_in => @customer.facebook_user?,
            :green_lit? => @customer.facebook_green_lit?,
          },
          :twitter => {
            :opt_in => @customer.twitter_user?,
            :green_lit? => @customer.twitter_green_lit?,
          }
        }
       else
        render :json => {:new_user => true}
       end
      }
    end
  end

  def create
    @customer = Customer.create(params[:customer])
    respond_with @customer do |format|
      format.json{
        if @customer.valid?
          render :json => {:new_user => true, :url => auth_url}
        else
          render :json => {:new_user => false, :error => @customer.errors}
        end
      }
    end
  end

  private 

  def auth_url 
    if @customer
       @customer.facebook_user? ? 
         FacebookApi.new.authorize_url(auth_success_customer_facebook_url(@customer)) :
         TwitterApi.new.authorize_url(auth_success_customer_twitter_url(@customer))
    end
  end



end
