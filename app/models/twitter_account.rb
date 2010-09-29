class TwitterAccount < ActiveRecord::Base

  belongs_to :customer

  def green_light? 
    self.token? and self.secret?
  end

  def client
    TwitterApi.client
  end

  def post(post)
    client.authorize_from_access(self.token, self.secret)
    twitter = Twitter::Base.new(client)
    twitter.update(post.message)
  end

end
