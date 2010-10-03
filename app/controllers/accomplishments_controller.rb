class AccomplishmentsController < ApplicationController
  include PostableMixin 

  respond_to :html, :json

  def new
    @accomplishment = Accomplishment
  end

  def create
    @customer = Customer.find_by_uuid(params[:uuid])
    language = Language.find_by_name params[:language].classify 
    if @customer and language
      @post = Post.create :message => "I have just completed a new lesson in #{language.name}", 
                          :posted_to_facebook => true, 
                          :customer => @customer
      @accomplishment = Accomplishment.create :language => language, :post => @post, :customer => @customer
      post_to_social_media
    elsif @customer.nil?
      raise "Could not locate the Customer by the given uuid"
    elsif language.nil?
      raise "Could not locate the Language by the given uuid"
    end
      
  rescue => e
    Rails.logger.info e.message
    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.message).deliver
  end

end
