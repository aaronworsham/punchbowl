class PostsController < ApplicationController
  
  before_filter :parse_post_to, :only => [:create]

  
  def create
    Post.create(params[:post])

    if post_to.include?("facebook")
      redirect_to "/facebook/auth?#{paramify_post_to}"
    elsif post_to.include?("twitter")
      redirect_to "/twitter/auth?#{paramify_post_to}"
    end
  end
end
