class FacebookApi

  #this will be a growing list of token related errors
  def self.token_error?(msg)
    case msg
    when "Error processing access token."
      return true
    else
      return false
    end
  end

  def self.handle_error(msg)
    case msg
    when "(#341) Feed action request limit reached"
      return "We have posted too many times to your wall today, please try again tomorrow."
    when "(#506) Duplicate status message"
      return "That message has already been posted to your wall"
    else
      return "Something has happened while posting to Facebook, please try again."
    end
  end
end
