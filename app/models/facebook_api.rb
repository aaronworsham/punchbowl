class FacebookApi

  #this will be a growing list of token related errors
  def self.token_error?(msg)
    msg = JSON.parse(msg)
    if msg["error"].present? 
      case msg["error"]["message"]
      when "Error processing access token."
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def self.handle_error(msg)
    msg = JSON.parse(msg)
    if msg["error"].present?
      case msg["error"]["message"]
      when "(#341) Feed action request limit reached"
        return "We have posted too many times to your wall today, please try again tomorrow."
      when "(#506) Duplicate status message"
        return "That message has already been posted to your wall"
      else
        return "Something has happened while posting to Facebook, please try again."
      end
    else
      return "Something has happened while posting to Facebook, please try again."
    end
  end

  def self.client
    settings = AppConfig.facebook
    OAuth2::Client.new(settings["key"], settings["secret"], :site => 'https://graph.facebook.com')
  end

  def self.authorize_url(uri)
    client.web_server.authorize_url(
        :redirect_uri => uri, 
        :scope => 'email,publish_stream,offline_access'
    )
  end

  def self.get_token(code, uri)
    access_token = client.web_server.get_access_token(code, :redirect_uri => uri) 
    access_token.token
  end


  def self.get_facebook_id(token)
    response = JSON.parse(token.get("/me"))
    Rails.logger.info response.inspect
    response["id"]
  end

end
