class TangoMailer < ActionMailer::Base
  default :from => "punchbowl@mangolanguage.com", 
          :to => "aaron@sazbean.com"

  def invitation(customer, partner)
    @customer = customer
    @partner = partner
    mail(:to => partner.email, 
         :subject => "Invitation to Tango with Mango")   
  end

  def reward(email, token)
    @token = token
    mail(:to => email,
         #:bcc => 'beverly.cornell@mangolanguage.com',
         :subject => 'We want to send you a thank you gift from Mango')
    
  end

  def fulfill(rewards)
    @rewards = rewards
    mail(#:to => 'beverly.cornell@mangolanguage.com',
         :subject => 'fufillment of Mango Tango')
    

  end
end
