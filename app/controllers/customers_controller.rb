class CustomersController < ApplicationController

  respond_to :json
  def show
    if params[:uuid]
      @customer = Customer.find_by_uuid(params[:uuid], :include => [:posts])
    end
    if @customer.present? 
      last_post = @customer.posts.last
      render :json => {
        :id => @customer.id,
        :uuid => @customer.uuid,
        :existing_user => true, 
        :facebook => {
          :token => @customer.try('facebook_account').try('token'),
          :opt_in => @customer.facebook_user?,
          :green_lit? => @customer.facebook_green_lit?,
        },
        :twitter => {
          :token => @customer.try('twitter_account').try('token'),
          :opt_in => @customer.twitter_user?,
          :green_lit? => @customer.twitter_green_lit?,
        },
        :last_error => @customer.last_error,
        :created_at => @customer.created_at.to_s(:long),
        :updated_at => @customer.updated_at.to_s(:long),
        :number_of_posts => @customer.posts.size,
        :last_post => {
          :message => last_post.message,
          :created_at => last_post.created_at.to_s(:long),
        }
      }
    else
      render :json => {:new_user => true}
    end
  end

  def create
    @customer = Customer.create(params[:customer])
    if params[:test_mode]
      @customer.test_account = true 
    end
    if @customer.valid?
      render :json => {:new_user => true, :url => auth_url}
    else
      render :json => {:new_user => false, :error => @customer.errors}
    end
  end

  private 

  def auth_url 
    if @customer
       @customer.facebook_user? ? 
         FacebookApi.new.authorize_url(auth_success_customer_facebook_url(@customer)) :
         TwitterApi.new(@customer).authorize_url(auth_success_customer_twitter_url(@customer))
    end
  end



end
