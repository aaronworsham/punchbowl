class ApplicationController < ActionController::Base
  protect_from_forgery

  def setup_post_to
    str = params[:post_to] || (params[:post] ? params[:post].delete(:post_to) : nil)
    @post_to = if str.present?
      URI.decode(str).gsub("+", " ").split()
    else
      []
    end
  end

  def paramify_post_to
    if @post_to.present?
      @post_to.join("+")
    else
      ""
    end
  end

  def twitter_post?
    @post_to.include?("twitter")

  end

  def facebook_post?
    @post_to.include?("facebook")
  end
end
