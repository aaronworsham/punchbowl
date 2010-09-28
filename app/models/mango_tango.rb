class MangoTango < ActiveRecord::Base
  has_many :dance_partners
  belongs_to :customer
end
