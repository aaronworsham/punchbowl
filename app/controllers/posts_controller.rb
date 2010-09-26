class PostsController < ApplicationController 
  before_filter :setup_post_to
  def create
    email = params[:post].delete(:email)
    customer = Customer.find_or_create_by_email(:email => email)
    post = Post.create(params[:post].merge(:customer => customer))

    if facebook_post? 
      redirect_to auth_post_facebook_path(post, :post_to => paramify_post_to)
    elsif twitter_post?
      redirect_to auth_post_twitter_path(post, :post_to => paramify_post_to)
    end
  end
end
