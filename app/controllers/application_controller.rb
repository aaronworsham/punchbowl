class ApplicationController < ActionController::Base
  protect_from_forgery

  def parse_post_to
    if params[:post_to]
      post_to = params[:post_to].split("+")
    end
  end
  def paramify_post_to
    if post_to.present?
      "post_to=#{post_to.join("+")}"
    else
      ""
    end
  end

  def twitter_post?
    post_to.include?("twitter")

  end

  def facebook_post?
    post_to.include?("facebook")
  end
end
