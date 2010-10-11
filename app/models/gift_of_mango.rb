class GiftOfMango < ActiveRecord::Base
  belongs_to :customer
  has_one :post, :as => :postable
  belongs_to :badge   

end
