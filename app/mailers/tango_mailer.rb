class TangoMailer < ActionMailer::Base
  default :from => "punchbowl@mangolanguage.com", 
          :to => "aaron@sazbean.com"

  def invitation(partner)
    mail(:to => partner.email, 
         :subject => "Invitation to Tango with Mango")   
  end
end
