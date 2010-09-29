module PostableMixin

  def post_to_social_media
    if @post.posted_to_facebook?
      if @customer.facebook_account and @customer.facebook_account.green_light?
        Rails.logger.info "Postable = Facebook greenlit" 
        conn.get post_message_post_facebook_path(@post)
        redirect_to @post.success_url
      else
        Rails.logger.info "Postable = Facebook redlit" 
        redirect_to auth_post_facebook_path(@post)
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_account and @customer.twitter_account.green_light?
        Rails.logger.info "Postable = twitter greenlit" 
        conn.get post_message_post_twitter_path(@post)
        redirect_to @post.success_url
      else
        Rails.logger.info "Postable = Facebook redlit" 
        redirect_to auth_post_twitter_path(@post)
      end
    end
  end 

  def conn
    Faraday::Connection.new(:url => AppConfig.site_domain)
  end
end
