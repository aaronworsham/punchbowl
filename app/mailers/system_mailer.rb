class SystemMailer < ActionMailer::Base
  default :from => AppConfig.email.default.from 
  default :to   => AppConfig.email.default.to 
  def warning_email(msg)
    @msg = msg
    mail(:subject => "A warning from Punchbowl")
  end

end
