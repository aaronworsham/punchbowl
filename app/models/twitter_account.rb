class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def has_credentials? 
    self.token? && self.secret? && self.verifier?
  end

  def get_authorize_url(callback_url) 
    oauth.set_callback_url(callback_url)
    self.token = oauth.request_token.token
    self.secret = oauth.request_token.secret
    self.save
    oauth.request_token.authorize_url
  end

  def authorize(verifier) 
    oauth.authorize_from_request(self.token, self.secret, verifier)
    self.verifier = verifier
    self.save
    true
  end

  def post(message)
    twitter = Twitter::Base.new(oauth)
    twitter.verify_credentials
    twitter.update(message)
  end

  private 

  def oauth 
    settings = AppConfig.twitter
    @oauth ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

end
