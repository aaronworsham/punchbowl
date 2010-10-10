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

end
