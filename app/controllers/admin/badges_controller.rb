class Admin::BadgesController < ApplicationController
  # GET /admin/badges
  # GET /admin/badges.xml

  layout 'scaffold'
  def index
    @admin_badges = Badge.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_badges }
    end
  end

  # GET /admin/badges/1
  # GET /admin/badges/1.xml
  def show
    @badge = Badge.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @badge }
    end
  end

  # GET /admin/badges/new
  # GET /admin/badges/new.xml
  def new
    @admin_badge = Badge.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_badge }
    end
  end

  # GET /admin/badges/1/edit
  def edit
    @admin_badge = Badge.find(params[:id])
  end

  # POST /admin/badges
  # POST /admin/badges.xml
  def create
    @admin_badge = Badge.new(params[:badge])

    respond_to do |format|
      if @admin_badge.save
        format.html { redirect_to(@admin_badge, :notice => 'Badge was successfully created.') }
        format.xml  { render :xml => @admin_badge, :status => :created, :location => @admin_badge }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/badges/1
  # PUT /admin/badges/1.xml
  def update
    @admin_badge = Badge.find(params[:id])

    respond_to do |format|
      if @admin_badge.update_attributes(params[:badge])
        format.html { redirect_to(admin_badges_path, :notice => 'Badge was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_badge.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/badges/1
  # DELETE /admin/badges/1.xml
  def destroy
    @admin_badge = Badge.find(params[:id])
    @admin_badge.destroy

    respond_to do |format|
      format.html { redirect_to(admin_badges_url) }
      format.xml  { head :ok }
    end
  end
end
