module FacebookApiMixin 

  def initialize(token = nil)
    @key = AppConfig.facebook["key"]
    @secret = AppConfig.facebook["secret"]
    @site = 'https://graph.facebook.com'
    @token = token
    super(@key, @secret, :site => @site)
  end

  def access_token(options = {})
    @token ||= begin
      resp = self.request(:get, access_token_url(
          {
            :client_id => @key,
            :client_secret => @secret,
            :grant_type => 'client_credentials'
          }
        )
      )
      CGI.parse(resp)["access_token"][0] 
    end
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info e.response.inspect if e.respond_to?('response')
    raise e
  end

  def request(verb, url, params = {}, headers = {})
    if verb == :get
      Rails.logger.info "Sending GET request to #{connection.build_url(url, params)}"
    else
      Rails.logger.info "Sending POST request to #{connection.build_url(url, params)}"
    end
    super(verb, url, params, headers)
  end

  def handle_error(msg)
    msg = JSON.parse(msg)
    if msg["error"].present?
      case msg["error"]["message"]
      when /341/
        return "We have posted too many times to your wall today, please try again tomorrow."
      when /506/
        return "That message has already been posted to your wall"
      when /100/
        return "We could not locate your user account at Facebook, please try again"
      else
        return "Something has happened while posting to Facebook, please try again."
      end
    else
      return "Something has happened while posting to Facebook, please try again."
    end
  end


  def post_to_wall(id, message)
    JSON.parse(self.request(:post, "/#{id}/feed", 
        {
          :message => message,
          :access_token => access_token
        }
      )
    )
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info "Has a repsonse"
    Rails.logger.error e.response.body
    Rails.logger.error e.response.headers
  end

  def read_from_wall(id)
    JSON.parse(self.request(:get, "/#{id}/feed", 
        {
          :access_token => access_token
        }
      )
    )
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info "Has a repsonse"
    Rails.logger.error e.response.body
    Rails.logger.error e.response.headers
  end


  def profile(id)
    resp = JSON.parse(self.request(:get, "/#{id}",{
        :access_token => access_token
      }
    ))
    return resp
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info e.response.inspect if e.respond_to?('response')
    raise e
  end

  #this will be a growing list of token related errors
  def token_error?(msg)
    msg = JSON.parse(msg)
    if msg["error"].present? 
      case msg["error"]["message"]
      when /100/
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
