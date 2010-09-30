class MangoTangosController < ApplicationController
  layout 'mango_tango'
  def new
    @tango = MangoTango.new
    @post = Post.new
  end
  def create
   customer = Customer.find_or_create_by_email(params[:mango_tango][:customer][:email])
   tango = MangoTango.create(:customer => customer)
   params[:mango_tango][:dance_partners].size.times do |i|
     if params[:mango_tango][:dance_partners][i.to_s][:email].present?
       tango.dance_partners << DancePartner.create(:email => params[:mango_tango][:dance_partners][i.to_s][:email]) 
     end
   end
  end
  def success
    @post = Post.new
    render 
  end
end
