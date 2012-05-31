class ApplicationController < ActionController::Base
  

  self.allow_forgery_protection = false

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def check_auth_key
    if Rails.env == "production"
      if !params[:auth_token] or params[:auth_token] != Punchbowl::Application.config.secret_token
        logger.info 'Failed auth token in production'
        render :nothing => true 
      end
    else 
      if !params[:auth_token] or params[:auth_token] != 'abcdef'
        logger.info 'Failed auth token not in production'
        render :nothing => true 
      end
    end
  end

  def auth_url(network = 'facebook')
    if @customer
       case network
         when 'facebook'
           FacebookApi.new.authorize_url(auth_success_customer_facebook_url(@customer))
         when 'twitter'
           TwitterApi.new(@customer).authorize_url(auth_success_customer_twitter_url(@customer))
       end
    end
  end

  def start_authorizing(network = 'facebook')
    if @customer
      case network
        when 'facebook'
          @customer.start_authorizing_facebook
        when 'twitter'
          @customer.start_authorizing_twitter
      end
    end
  end

  def deauthorize(network = 'facebook')
    if @customer
      case network
        when 'facebook'
          @customer.deauthorize_facebook
        when 'twitter'
          @customer.deauthorize_twitter
      end
    end
  end

end
