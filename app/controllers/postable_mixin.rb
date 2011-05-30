module PostableMixin

  def post_to_social_media
    if params[:test_mode] or @customer.test_account
      type = 'tested'
    elsif @customer.facebook_user? or @costomer.twitter_user?
      response = ""
      if @customer.facebook_user? and @customer.facebook_green_lit?
        response += @customer.facebook_account.post_to_wall(@post)
      end
      if @customer.twitter_user? and @customer.twitter_green_lit?
        response += @customer.twitter_account.post(@post)
      end
      status = "posted" 
    else
      status = 'customer is not a facebook or twitter user'
    end
     render :json =>  {:status => type, :response => response}
  rescue 
    raise
  end 

end
