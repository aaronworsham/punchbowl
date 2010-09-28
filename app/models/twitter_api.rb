class TwitterApi

  #this will be a growing list of token related errors
  def self.token_error?(msg)
    return false
  end

  def self.handle_error(msg)
    return "Something has happened while posting to Twitter, please try again."
  end

  def self.client 
    settings = AppConfig.twitter
    @client ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def self.authorize_url(uri) 
    client.set_callback_url(uri)
    session[:twitter_request_token] = client.request_token.token
    session[:twitter_request_secret] = client.request_token.secret
    client.request_token.authorize_url
  end

  def verify(verifier) 
    if session[:twitter_token] and session[:twitter_secret]
      client.authorize_from_request(self.token, self.secret, verifier)
      Twitter::Base.new(client).verify_credentials
      return [client.access_token.token, client.access_token.secret]
    else
      raise "Session information for twitter were missing, could not verify"
    end
  end



end
