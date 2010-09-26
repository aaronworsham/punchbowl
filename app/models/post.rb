class Post < ActiveRecord::Base
  belongs_to :postable, :polymorphic => true
  belongs_to :customer

  attr_accessor :email
end
