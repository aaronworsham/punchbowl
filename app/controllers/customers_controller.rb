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
        :anonymous => @customer.anonymous?,
        :facebook => {
          :token => @customer.try('facebook_account').try('token'),
          :opt_in => @customer.facebook_user?,
          :greenlit? => @customer.facebook_greenlit?,
          :auth_state => @customer.facebook_auth_state
        },
        :twitter => {
          :token => @customer.try('twitter_account').try('token'),
          :opt_in => @customer.twitter_user?,
          :greenlit? => @customer.twitter_greenlit?,
          :auth_state => @customer.twitter_auth_state
        },
        :last_error => @customer.last_error,
        :created_at => @customer.created_at.to_s(:long),
        :updated_at => @customer.updated_at.to_s(:long),
        :number_of_posts => @customer.posts.size,
        :last_post => {
          :created_at => (last_post ? last_post.created_at.to_s(:long) : nil),
        }
      }
    else
      render :json => {:new_user => true}
    end
  end

  def create
    @customer = Customer.create(params[:customer])
    if @customer.valid?
      start_authorizing(@customer.first_network)
      render :json => {:new_user => true, :network => (@customer.first_network), :url => auth_url(@customer.first_network) }
    else
      render :json => {:new_user => false, :error => @customer.errors}
    end
  end

  def add_network
    @customer = Customer.find_by_uuid params[:uuid]
    if @customer
      case params[:network]
        when 'facebook'
          unless @customer.facebook_user?
            @customer.update_attribute(:facebook_user, true)
            start_authorizing('facebook')
            render :json => {:network => 'facebook', :added => true, :url => auth_url('facebook')}
          else
            render :json => {:network => 'facebook', :added => false, :error => 'Already facebook user'}
          end
        when 'twitter'
          unless @customer.twitter_user?
            @customer.update_attribute(:twitter_user, true)
            start_authorizing('twitter')
            render :json => {:network => 'twitter', :added => true, :url => auth_url('twitter')}
          else
            render :json => {:network => 'twitter', :added => false, :error => 'Already twitter user'}
          end
      end
    else
      render :json => {:network => params[:network], :removed => false, :error => "Could not locate Customer with uuid #{params[:uuid]}"}
    end
  end

  def remove_network
    @customer = Customer.find_by_uuid params[:uuid]
    if @customer
      case params[:network]
        when 'facebook'
          if @customer.facebook_user?
            @customer.update_attribute(:facebook_user, false)
            deauthorize('facebook')
            render :json => {:network => 'facebook', :removed => true}
          else
            render :json => {:network => 'facebook', :removed => false, :error => 'Not a Facebook user'}
          end
        when 'twitter'
          if @customer.twitter_user?
            @customer.update_attribute(:twitter_user, false)
            deauthorize('twitter')
            render :json => {:network => 'twitter', :removed => true}
          else
            render :json => {:network => 'twitter', :removed => false, :error => 'Not a Twitter user'}
          end
      end
    else
      render :json => {:network => params[:network], :removed => false, :error => "Could not locate Customer with uuid #{params[:uuid]}"}
    end
  end

  def reauthorize
    @customer = Customer.find_by_uuid params[:uuid]
    if @customer
      case params[:network]
        when 'facebook'
          if @customer.facebook_user?
            start_authorizing('facebook')
            render :json => {:network => 'facebook',:authorizing => true, :url => auth_url('facebook')}
          else
            render :json => {:network => 'facebook', :authorizing => false, :error => 'Not a Facebook user'}
          end
        when 'twitter'
          if @customer.twitter_user?
            start_authorizing('twitter')
            render :json => {:network => 'twitter',:authorizing => true, :url => auth_url('twitter')}
          else
            render :json => {:network => 'twitter', :authorizing => false, :error => 'Not a Twitter user'}
          end
      end
    else
      render :json => {:network => params[:network], :removed => false, :error => "Could not locate Customer with uuid #{params[:uuid]}"}
    end
  end

  private







end
