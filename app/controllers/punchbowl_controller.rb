class PunchbowlController < ApplicationController

  def index
    respond_to do |wants|
      wants.html { Rails.logger.info "Wants HTML" }
      wants.json { Rails.logger.info "Wants JSON"; render :json => "test".to_json}
    end
  end

  def success

  end
end
