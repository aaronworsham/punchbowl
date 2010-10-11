class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  belongs_to :customer

  attr_accessor :email, :post_to, :source

  named_scope :accomplishments, :conditions => ['posts.postable_type = ?', "Accomplishment"]

  def green_lit?
    facebook_green = if facebook? 
      customer.facebook_account and customer.facebook_account.green_light?
    else
      true
    end

    twitter_green = if twitter? 
      customer.twitter_account and customer.twitter_account.green_light?
    else
      true
    end
    facebook_green and twitter_green
  end

  def facebook?
    !!posted_to_facebook
  end

  def facebook_url
    return false unless facebook_id.present?
    'https://graph.facebook.com/' + self.facebook_id + "?access_token=" + self.customer.facebook_account.token
  end


  def twitter?
    !!posted_to_twitter
  end

  def accomplishment?
    postable_type == "Accomplishment"
  end

  def create_url
    return "/" unless postable_type
    case postable_type
    when "GiftOfMango"
      "/gift_of_mango/"
    when "MangoTango"
      "/posts/"
    else
      "/posts"
    end
  end

  def success_url
    "/posts/success"
  end

end
