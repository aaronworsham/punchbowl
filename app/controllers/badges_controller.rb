class BadgesController < ApplicationController
  def show
    @badge = Badge.find params[:id]
  end

  def index
    @badges = Badge.all
  end

end
