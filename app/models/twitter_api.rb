class TwitterApi

  def client 
    settings = AppConfig.twitter
    @client ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

  def authorize_url(uri) 
    client.set_callback_url(uri) 
    client.request_token.authorize_url 
  end

  def verify(token, secret, verifier) 
    if token and secret and verifier
      client.authorize_from_request(token, secret, verifier)
      Twitter::Base.new(client).verify_credentials
      return [client.access_token.token, client.access_token.secret]
    else
      raise "Session information for twitter were missing, could not verify"
    end
  end



end
