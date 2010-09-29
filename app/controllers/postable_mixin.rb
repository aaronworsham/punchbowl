module PostableMixin

  def post_to_social_media
    if @post.posted_to_facebook? and @post.posted_to_twitter?
      if @customer.facebook_account.green_light? and @customer.twitter_account.green_light?
        Rails.logger.info "Postable = Facebook and Twitter greenlit" 
        json_get post_message_post_facebook_path(@post)
        json_get post_message_post_twitter_path(@post)
        redirect_to @post.success_url
      else
        Rails.logger.info "Postable = Facebook or Twitter redlit" 
        redirect_to auth_post_facebook_path(@post)
      end
    elsif @post.posted_to_facebook?
      if @customer.facebook_account and @customer.facebook_account.green_light?
        Rails.logger.info "Postable = Facebook greenlit" 
        json_get post_message_post_facebook_path(@post)
        redirect_to @post.success_url
      else
        Rails.logger.info "Postable = Facebook redlit" 
        redirect_to auth_post_facebook_path(@post)
      end
    elsif @post.posted_to_twitter?
      if @customer.twitter_account and @customer.twitter_account.green_light?
        Rails.logger.info "Postable = Twitter greenlit" 
        json_get post_message_post_twitter_path(@post)
        redirect_to @post.success_url
      else
        Rails.logger.info "Postable = Twitter redlit" 
        redirect_to auth_post_twitter_path(@post)
      end
    end
  end 

  def json_get(url)
    conn.get do |req|
      req.url  url
      req.content_type  'application/json'
    end
  end

  def conn
    conn = Faraday::Connection.new(:url => 'http://sushi.com') do |builder|
      builder.use Faraday::Request::Yajl     # convert body to json with Yajl lib
      builder.use Faraday::Adapter::Logger   # log the request somewhere?
      builder.use Faraday::Adapter::Typhoeus # make http request with typhoeus
      builder.use Faraday::Response::Yajl    # # parse body with yajl
    end
  end
end
