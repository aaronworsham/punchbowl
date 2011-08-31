module PostableMixin

  def post_to_social_media
    if params[:test_mode]
      type = 'tested'
    elsif @customer.facebook_user? or @customer.twitter_user?
      response = {}
      if @customer.facebook_user? and @customer.facebook_greenlit?
        response[:facebook] = @customer.facebook_account.post_to_wall(@post)
      end
      if @customer.twitter_user? and @customer.twitter_greenlit?
        response[:twitter] = @customer.twitter_account.post(@post)
      end
      status = "posted" 
    else
      status = 'customer is not a facebook or twitter user'
    end
      render :json =>  {:status => status}
  rescue 
    raise
  end 

end
