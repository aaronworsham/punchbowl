class PunchbowlController < ApplicationController
  def index
    @post = Post.new
  end
end
