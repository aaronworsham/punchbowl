class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def greenlit? 
    self.token? and self.secret?
  end

  def api
    @api ||= TwitterApi.new(customer)
  end

  def post(post)
    response = api.post_to_timeline(post)
    Rails.logger.info response.inspect
    'success'
  rescue => e
    Rails.logger.info e.message
    if e.respond_to?("response")
      Rails.logger.error e.response.inspect
    end
    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    raise e.message
  end

  def last_post
    api.last_post
  end

  def valid_auth?
    api.valid_auth?
  end

end
