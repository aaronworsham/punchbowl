class AccomplishmentsController < ApplicationController
  include PostableMixin 

  layout 'accomplishments'
  respond_to :html, :json

  def new
    @accomplishment = Accomplishment
  end

  def create
    uuid = params[:uuid]
    language = Language.find_by_name params[:language]
    badge = Badge.find_by_name params[:badge_name]
    message = params[:message]
    if uuid.present?
      @customer = Customer.find_by_uuid(params[:uuid]) || Customer.create(
          :facebook_user => params[:post_to_facebook],
          :twitter_user => params[:post_to_twitter],
          :wants_to_share => true,
          :wants_to_be_asked => params[:remember_me],
          :uuid => uuid
        )
    else 
      @customer = Customer.create(
        :name => 'Anonymous',
        :facebook_user => params[:post_to_facebook],
        :twitter_user => params[:post_to_twitter],
        :wants_to_share => false,
        :wants_to_be_asked => false
      )
    end
    if @customer and language and message and badge
      @post = Post.create :message => message, 
                          :posted_to_facebook => @customer.facebook_user?,
                          :posted_to_twitter => @customer.twitter_user?, 
                          :customer => @customer
      @accomplishment = Accomplishment.create :language => language, 
                                              :post => @post, 
                                              :customer => @customer, 
                                              :badge => badge
      post_to_social_media
    elsif @customer.nil?
      raise "Could not locate the Customer by the given uuid or Anonymous "
    elsif language.nil?
      raise "Could not locate the Language by the given uuid"
    elsif message.nil?
      raise "A message was not passed in"
    elsif badge.nil?
      raise "Could not locate badge"
    end
  rescue => e
    Rails.logger.info e.message
    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.message).deliver
  end

end
