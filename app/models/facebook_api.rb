class FacebookApi < OAuth2::Client

  include FacebookApiMixin

  def authorize_url(uri, scope = nil)
    Rails.logger.info "Authorize URL Facebook API"
    super(
      {
        :client_id => @key,
        :redirect_uri => uri, 
        :scope => (scope || 'email,read_stream,publish_stream,offline_access')
      }
    )
  end

  def verify(code, uri)
    Rails.logger.info "Verifying in Facebook API"
    local_token = self.web_server.get_access_token(code, :redirect_uri => uri)
    Rails.logger.info "-----local_token-----"
    Rails.logger.info local_token.inspect
    response = JSON.parse(local_token.get("/me"))
    Rails.logger.info "-----ID Response-----"
    Rails.logger.info response.inspect
    return [response["id"], local_token.token]
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.response.inspect if e.respond_to?("response")
    raise e
  end




end
