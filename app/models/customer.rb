class Customer < ActiveRecord::Base
  has_many :posts
end
