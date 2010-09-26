class PunchbowlController < ApplicationController
  before_filter :new_post, :only => [:index, :test_facebook, :test_twitter]
  
  def index
  end

  def test_facebook
  end

  def test_twitter
  end

  def success

  end

  private
  def new_post
    @post = Post.new
  end
end
