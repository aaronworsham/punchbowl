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


  def success_url
    case postable_type
    when "GiftOfMango"
      "/gift_of_mango/success"
    else
      "/"
    end
  end

  def update_template
    case postable_type
    when "GiftOfMango"
      "/gift_of_mango/new"
    else
      "/"
    end
  end
end
