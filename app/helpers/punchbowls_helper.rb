module PunchbowlsHelper
  def default_message_copy(source)
    case source
    when "gift_of_mango"
      "I gave the gift of language learning to someone special. Find out how you can too! http://trymango.com"
    when "mango_tango"
      "I did the Mango Tango! Tell a friend about our language learning program, and you can tango too. http://trymango.com"
    else
      nil
    end
  end
end
