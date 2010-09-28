class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def valid? 
    self.token? and self.secret?
  end

  def post(message)
    oauth.authorize_from_access(self.token, self.secret)
    twitter = Twitter::Base.new(oauth)
    twitter.update(message)
  end

end
