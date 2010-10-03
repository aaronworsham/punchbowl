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
    response = JSON.parse(access_token.post("/#{self.facebook_id}/feed", build_message(post))) 
    Rails.logger.info response.inspect
    response
  rescue => e
    Rails.logger.info e.message
      Rails.logger.info "Has a repsonse"
      Rails.logger.error e.response.body
      Rails.logger.error e.response.headers

    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    self.update_attributes(:token => nil, :secret => nil) if FacebookApi.token_error?(e.response.body) 
      raise FacebookApi.handle_error(e.message)
    
  end


  def post_to_my_wall(post)
    response = JSON.parse(access_token.post("/me/feed", build_message(post))) 
    Rails.logger.info response.inspect
    response
  rescue => e
    Rails.logger.info e.message
      Rails.logger.info "Has a repsonse"
      Rails.logger.error e.response.body
      Rails.logger.error e.response.headers

    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    self.update_attributes(:token => nil, :secret => nil) if FacebookApi.token_error?(e.response.body) 
        
      raise FacebookApi.handle_error(e.message)

  end

  def build_message(post)
    if post.accomplishment?
      params = { 
        :message  => post.message, 
        :picture  => AppConfig.url + post.postable.language.badge.image_path,
        :link     => AppConfig.url + post.postable.language.badge.image_path,
        :name     => post.postable.language.badge.name,
        :caption  => post.postable.language.badge.name
      }
      Rails.logger.info "Params to Facebook:" + params.inspect
      params 
    else
      {:message => post.message}
    end
  end

end
