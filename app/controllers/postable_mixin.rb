module PostableMixin

  def post_to_social_media
    if params[:test_mode]
      type = 'tested'
    elsif @post.posted_to_facebook?
      if @customer.facebook_user?
        if @customer.facebook_greenlit? and @customer.facebook_account.valid_auth?
          success = true
          status = @customer.facebook_account.post_to_wall(@post)
        else
          deauthorize('facebook')
          success = false
          error = 'Customer not authorized to Facebook'
          url = auth_url('facebook')
        end
      else
        success = false
        error = 'Customer not a Facebook User'
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_user?
        if @customer.twitter_greenlit? and @customer.twitter_account.valid_auth?
          success = true
          status = @customer.twitter_account.post(@post)
        else
          deauthorize('twitter')
          success = false
          error = 'Customer not authorized to Twitter'
          url = auth_url('twitter')
        end
      else
        success = false
        error = 'Customer not a Twitter User'
      end
    else
      success = false
      error = 'Please select a supported Network, IE Facebook or Twitter'
    end
    if success
      render :json =>  {:success => success, :status => status}
    else
      render :json =>  {:success => success, :status => status, :error => error, :url => url}
    end
  rescue 
    raise
  end 

end
