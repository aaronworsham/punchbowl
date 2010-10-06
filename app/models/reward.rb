class Reward < ActiveRecord::Base
  belongs_to :rewardable, :polymorphic => true
  belongs_to :customer
end
