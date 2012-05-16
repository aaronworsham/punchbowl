module PostableMixin

  def post_to_social_media
    if params[:test_mode]
      type = 'tested'
    elsif @post.posted_to_facebook?
      if @customer.facebook_user?
        if @customer.facebook_greenlit?
          success = true
          status = @customer.facebook_account.post_to_wall(@post)
        else
          success = false
          error = 'Customer not authorized to Facebook'
        end
      else
        success = false
        error = 'Customer not a Facebook User'
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_user?
        if @customer.twitter_greenlit?
          success = true
          status = @customer.twitter_account.post(@post)
        else
          success = false
          error = 'Customer not authorized to Twitter'
        end
      else
        success = false
        error = 'Customer not a Twitter User'
      end
    else
      success = false
      error = 'Please select a supported Network, IE Facebook or Twitter'
    end
    render :json =>  {:success => success, :status => status, :error => error}
  rescue 
    raise
  end 

end
