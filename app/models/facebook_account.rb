class FacebookAccount < ActiveRecord::Base

  belongs_to :customer


  def green_light?
    #TODO test the token with facebook?
    self.token.present? and self.facebook_id.present?
  end

  def access_token
    FacebookApi.access_token(self.token)
  end

  def rest_connection
    FacebookApi.rest_connection
  end

  def post_to_wall(post)
    response = JSON.parse(access_token.post("/#{self.facebook_id}/feed", build_message(post))) 
    Rails.logger.info response.inspect
    post.update_attribute("facebook_id", response["id"]) if response["id"].present?
    response
  rescue => e
    Rails.logger.info e.message
      Rails.logger.info "Has a repsonse"
      Rails.logger.error e.response.body
      Rails.logger.error e.response.headers

    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message)   
    self.update_attributes(:token => nil) if FacebookApi.token_error?(e.response.body) 
      raise FacebookApi.handle_error(e.response.body)
    
  end

  def stream_publish_path(post)
    return false unless facebook_id.present? and token.present?
    '/method/stream.publish?uid=' + facebook_id + "&access_token=" + token 
  end

  def post_to_stream(post)
    Rails.logger.info "Params :" + build_stream(post).inspect 
    resp = rest_connection.post do |p|
      p.url stream_publish_path(post) 
      p.body = {
        :message => post.message, 
        :attachment => media(post)
      }
    end
    Rails.logger.info resp.inspect
    resp
  end

  def post_to_my_wall(post)
    response = JSON.parse(access_token.post("/me/feed", build_message(post))) 
    Rails.logger.info response.inspect
    post.update_attribute("facebook_id", response["id"]) if response["id"].present?
    response
  rescue => e
    Rails.logger.info e.message
      Rails.logger.info "Has a repsonse"
      Rails.logger.error e.response.body
      Rails.logger.error e.response.headers

    #TODO uncomment once we get an smtp server set
    #SystemMailer.warning_email(e.response.body).deliver
    customer.update_attribute(:last_error, e.message) 
    self.update_attributes(:token => nil) if FacebookApi.token_error?(e.response.body) 
        
      raise FacebookApi.handle_error(e.response.body)

  end

  def build_message(post)
    if post.accomplishment?
      {
        :message => post.message,
        :picture => "http://punchbowl.heroku.com" + post.postable.language.badge.image_path,
        :caption => post.postable.language.name
      }
    else
      {:message => post.message}
    end
  end

  def build_stream(post)
    { :message => post.message,  
      :attachment   => media(post)
      }
  end

  def media(post)
      {
        :media => [{
            :type => 'image',
            :src  => "http://punchbowl.heroku.com" + post.postable.language.badge.image_path,
            :href => "http://punchbowl.heroku.com/badges",
          }]
      
      }.to_json
  end

end
