class PostsController < ApplicationController
  
  before_filter :parse_post_to, :only => [:create]

  
  def create
    Post.create(params[:post])

    if facebook_post? 
      redirect_to "/facebook/auth?#{paramify_post_to}"
    elsif twitter_post?
      redirect_to "/twitter/auth?#{paramify_post_to}"
    end
  end
end
