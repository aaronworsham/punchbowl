class TwitterAccount < ActiveRecord::Base
  belongs_to :customer

  def has_credentials? 
    self.token? && self.secret? && self.verifier?
  end

end
