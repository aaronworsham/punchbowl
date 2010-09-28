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
    Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def self.authorize_url(uri) 
    oauth.set_callback_url(uri)
    session[:twitter_request_token] = oauth.request_token.token
    session[:twitter_request_secret] = oauth.request_token.secret
    oauth.request_token.authorize_url
  end

  def verify(verifier) 
    if session[:twitter_token] and session[:twitter_secret]
      oauth.authorize_from_request(self.token, self.secret, verifier)
      Twitter::Base.new(oauth).verify_credentials
      return [oauth.access_token.token, oauth.access_token.secret]
    else
      raise "Session information for twitter were missing, could not verify"
    end
  end



end
