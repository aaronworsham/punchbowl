class FacebookAccount < ActiveRecord::Base

  belongs_to :customer

  


  def green_light?
    #TODO test the token with facebook?
    self.token.present? and self.facebook_id.present?
  end

  def access_token
    FacebookApi.access_token(self.token)
  end

  def post_to_wall(post)
    response = JSON.parse(access_token.post("/#{self.facebook_id}/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  rescue => e
    Rails.logger.info e.message
    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    self.update_attributes(:token => nil, :secret => nil) if FacebookApi.token_error?(e.message) 
    if e.respond_to?("response")
      Rails.logger.error e.response.inspect
      raise FacebookApi.handle_error(e.message)
    else
      raise FacebookApi.e.message
    end
    
  end


  def post_to_my_wall(post)
    response = JSON.parse(access_token.post("/me/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  rescue => e
    Rails.logger.info e.message
    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    self.update_attributes(:token => nil, :secret => nil) if FacebookApi.token_error?(e.message) 
    if e.respond_to?("response")
      Rails.logger.error e.response.inspect
      raise FacebookApi.handle_error(e.message)
    else
      raise FacebookApi.e.message
    end
  end

end
