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

end
