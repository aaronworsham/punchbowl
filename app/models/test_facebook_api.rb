class TestFacebookApi < OAuth2::Client

  include FacebookApiMixin

  def add_test_user
    resp = JSON.parse(self.request(:get, "/#{@key}/accounts/test-users",{
        :installed => true,
        :permissions => "read_stream,publish_stream",
        :method => :post,
        :access_token => access_token
      }
    ))
    Rails.logger.info "Added Test User ID #{resp["id"]}"
    return [resp, self.class.new(resp["access_token"])]
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info e.response.inspect if e.respond_to?('response')
    raise e
  end

  def delete_test_user(user)
    resp = self.request(:get, "/#{user["id"]}",{
        :method => :delete,
        :access_token => access_token
      }
    )
    Rails.logger.info "Removed Test User ID #{user["id"]}: #{resp}"
    return resp
  rescue => e
    Rails.logger.info e.message
    Rails.logger.info e.response.inspect if e.respond_to?('response')
    raise e
  end


end

