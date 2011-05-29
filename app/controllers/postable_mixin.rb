module PostableMixin

  def post_to_social_media
    if params[:test_mode]
      type = 'tested'
    elsif @customer.facebook_user? and @customer.facebook_green_lit?
      response = @customer.facebook_account.post_to_wall(@post)
      status = 'posted'
    elsif @customer.twitter_user? and @customer.twitter_green_lit?
      response = @customer.twitter_account.post(@post)
      status = 'posted'
    else
      status = 'error'
    end
    respond_to do |x|
      x.json{ render :json =>  {:status => type, :response => response}}
    end
  rescue 
    raise
  end 

end
