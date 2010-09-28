class PostsController < ApplicationController 
  
  def create
    self.email= params[:post].delete(:email)
    @customer = Customer.find_or_create_by_email(:email => email)
    @post = Post.create(params[:post].merge(:customer => @customer))
    redirect_post
  end

  def update
    @post = Post.find params[:id]
    @customer = @post.customer
    redirect_post
  end

  private
  
  def redirect_post
    if @post.posted_to_facebook?
      if @customer.facebook_account 
        redirect_to post_message_post_facebook_path(@post)
      else
        redirect_to auth_post_facebook_path(@post)
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_account
        redirect_to post_message_post_twitter_path(@post)
      else
        redirect_to auth_post_twitter_path(@post)
      end
    end
  end

end
