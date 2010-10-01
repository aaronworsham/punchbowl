class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  belongs_to :customer

  attr_accessor :email, :post_to

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

  def twitter?
    !!posted_to_twitter
  end

  def create_url
    return "/" unless postable_type
    case postable_type
    when "GiftOfMango"
      "/gift_of_mango/"
    when "MangoTango"
      "/mango_tango/"
    else
      "/posts"
    end
  end

  def success_url
    "/posts/success"
  end

end
