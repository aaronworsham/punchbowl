class DancePartner < ActiveRecord::Base
  belongs_to :mango_tango

  after_create :email_tango

  def email_tango
    TangoMailer.invitation(mango_tango.customer, self).deliver
  end
end
