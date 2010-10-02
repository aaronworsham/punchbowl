class Accomplishment < ActiveRecord::Base
  belongs_to :customer
  has_one :post, :as => :postable
  belongs_to :language
end
