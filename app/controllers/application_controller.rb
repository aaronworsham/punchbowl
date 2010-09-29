class ApplicationController < ActionController::Base
  protect_from_forgery

  def email
    session[:email] ||= params[:email]
  end

  def email=(e)
    session[:email] = e
  end

  def current_customer 
    Customer.find_or_create_by_email email
  end




end
