class FacebookAccount < ActiveRecord::Base

  belongs_to :customer

  

  def initialize
    @client = FacebookApi.client
  end

  def valid?
    #TODO test the token with facebook?
    self.token.present? and self.facebook_id.present?
  end

  def access_token
    FacebookApi.access_token(self.token)
  end

  def post_to_wall(post)
    response = JSON.parse(access_token.post("/#{self.facebook_id}/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  end

  def post_to_my_wall(post)
    response = JSON.parse(access_token.post("/me/feed", :message => post.message)) 
    Rails.logger.info response.inspect
    response
  end

  private

  

end
