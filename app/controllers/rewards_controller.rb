class RewardsController < ApplicationController
  def edit
    @reward = Reward.find_by_token params[:token]
  end

  def update
    @reward = Reward.find_by_id params[:id]
    @reward.update_attributes(params[:reward].merge(:redeemed_at => Time.now))
  end
end
