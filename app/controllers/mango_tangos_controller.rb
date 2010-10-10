class MangoTangosController < ApplicationController
  layout 'mango_tango'
  def new
    @tango = MangoTango.new
    @post = Post.new
  end
  def create
   customer = Customer.find_or_create_by_email(params[:mango_tango][:customer][:email])
   customer.update_attribute(:name, params[:mango_tango][:customer][:name]) if params[:mango_tango][:customer][:name].present?
   tango = MangoTango.create(:customer => customer)
   params[:mango_tango][:dance_partners].size.times do |i|
     if params[:mango_tango][:dance_partners][i.to_s][:email].present?
       DancePartner.create(:email => params[:mango_tango][:dance_partners][i.to_s][:email], 
                           :mango_tango => tango,
                           :name => params[:mango_tango][:dance_partners][i.to_s][:name]) 
     end
   end
   render :nothing => true
  end
  def success
    @post = Post.new
    render 
  end
end
