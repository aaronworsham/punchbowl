class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  belongs_to :customer

  attr_accessor :email, :post_to

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
