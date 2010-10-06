class MangoTango < ActiveRecord::Base
  include TokenGenerator
  has_many :dance_partners
  belongs_to :customer
  has_one :reward, :as => :rewardable, :order => 'created_at DESC'

end
