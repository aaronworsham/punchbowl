class BadgesController < ApplicationController
  respond_to :html, :json
  
  def show
    if params[:id]
      @badge = Badge.find_by_id params[:id]
    elsif params[:badge_name]
      @badge = Badge.find_by_name params[:badge_name].classify
    end
    respond_with @badge
  end

  def index
    @badges = Badge.all
  end

end
