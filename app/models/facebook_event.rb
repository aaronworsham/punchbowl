class FacebookEvent < ActiveRecord::Base
has_many :posts, :as => :postable

end
