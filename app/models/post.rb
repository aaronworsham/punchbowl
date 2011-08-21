class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  belongs_to :customer

  attr_accessor :email, :post_to, :source, :uuid



  def facebook?
    !!posted_to_facebook
  end

  # def facebook_url
  #   return false unless facebook_id.present?
  #   'https://graph.facebook.com/' + self.facebook_id + "?access_token=" + self.customer.facebook_account.token
  # end

  def twitter?
    !!posted_to_twitter
  end

end
