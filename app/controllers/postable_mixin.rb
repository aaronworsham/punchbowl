module PostableMixin

  def post_to_social_media

    #Post is for Facebook and Twitter
    if @post.green_lit?
      if @post.facebook?
        Rails.logger.info "Postable :: Facebook greenlit" 
        response = @customer.facebook_account.post_to_wall(@post)
        Rails.logger.info response.inspect
      end
      if @post.twitter?
        Rails.logger.info "Postable :: Twitter greenlit" 
        response = @customer.twitter_account.post(@post)
        Rails.logger.info response.inspect
      end
      url = @post.success_url
    else
      if @post.facebook?
        Rails.logger.info "Postable = Facebook redlit"
        url = auth_post_facebook_path(@post)
      elsif @post.twitter? and !@post.facebook?
        Rails.logger.info "Postable = Twitter redlit" 
        url = auth_post_facebook_path(@post)
      end
    end
    respond_with(@post) do |format|
      format.html{redirect_to url }
    end
  end 

end
