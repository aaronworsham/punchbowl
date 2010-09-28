class MangoTangosController < ApplicationController
  layout 'mango_tango'
  def new
    @tango = MangoTango.new
  end
  def create
    
  end
end
