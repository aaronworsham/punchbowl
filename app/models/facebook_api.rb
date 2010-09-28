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

  def initialize(customer)
    @client = FacebookApi.client 
    @customer = customer
  end

  def access_token
    @token ||= access_token = OAuth2::AccessToken.new(@client, @customer.facebook_token)
  end

  def post_to_wall(post)
    response = JSON.parse(access_token.post("/#{@customer.facebook_id}/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  end

  def post_to_my_wall(post)
    response = JSON.parse(@token.post("/me/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  end

  def get_token(code, uri)
    @token = @client.web_server.get_access_token(code, :redirect_uri => uri) 
  end

  def get_id_and_token(code, uri)
    get_token(code, uri)
    response = JSON.parse(@token.get("/me"))
    Rails.logger.info response.inspect
    {:facebook_token => @token.token, :facebook_id => response["id"]}
  end
end
