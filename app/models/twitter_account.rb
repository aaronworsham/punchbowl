class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def has_credentials? 
    self.token? && self.secret? && self.verifier?
  end

  def set_callback_url(url) 
    oauth.set_callback_url(url)
    self.token = oauth.request_token.token
    self.secret = oauth.request_token.secret
    self.save
  end

  private 

  def oauth 
    settings = AppConfig.twitter
    @oauth ||= Twitter::OAuth.new(settings["key"], settings["secret"])
  end

end
