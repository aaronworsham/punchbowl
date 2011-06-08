class TwitterApi

  def initialize(customer)
    @customer = customer
  end

  def client 
    settings = AppConfig.twitter
    @client ||= if @customer.twitter_green_lit?
      TwitterOAuth::Client.new(
        :consumer_key => settings["key"],
        :consumer_secret => settings["secret"],
        :token => @customer.twitter_account.token,
        :secret => @customer.twitter_account.secret)
    else
      TwitterOAuth::Client.new(
        :consumer_key => settings["key"],
        :consumer_secret => settings["secret"])
    end
  end

  def request_token(uri)
    client.request_token(:oauth_callback => uri)
  end

  def authorize_url(uri)
    token = request_token(uri)
    Rails.cache.write("customer_#{@customer.id}_twitter_token", token)
    token.authorize_url 
  end

  def verify(verifier) 
    request_token = Rails.cache.read("customer_#{@customer.id}_twitter_token") 
    client.authorize(request_token.token, request_token.secret, :oauth_verifier => verifier)
  end



end
