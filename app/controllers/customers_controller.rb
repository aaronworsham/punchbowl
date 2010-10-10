class CustomersController < ApplicationController
  respond_to :json, :xml
  def show
    if params[:uuid]
      @customer = Customer.find_by_uuid(params[:uuid])
    elsif params[:email]
      @customer = Customer.find_by_email(params[:email])
    else
      @customer = nil
    end
    respond_with @customer do |format|
      format.json{
       if @customer.present? 
        render :json => @customer.attributes.merge(:green_lit => @customer.green_lit?)
       else
        render @customer
       end
      }      
    end
  end
  def test
    case params[:uuid]
    when "1"
      @customer = Customer.find_by_uuid(params[:uuid])
      green_lit = true
    when "unknown"
      @customer = nil
    when "no_sharing"
      @customer = Customer.find_by_uuid(1)
      @customer.wants_to_share = false
      green_lit = true
    when "ask_first"
      @customer = Customer.find_by_uuid(1)
      @customer.wants_to_be_asked = true
      green_lit = true
    when "red_lit"
      @customer = Customer.find_by_uuid(1)
      green_lit = false
    end
    respond_with @customer do |format|
      format.json{
       if @customer.present? 
        render :json => @customer.attributes.merge(:green_lit => green_lit )
       else
        render @customer
       end
      }      
    end
  end

end
