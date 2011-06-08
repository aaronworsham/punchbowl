class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def green_light? 
    self.token? and self.secret?
  end

  def client
    @client ||= TwitterApi.new(customer).client
  end

  def post(post)
    client.update(post.message)
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

end
