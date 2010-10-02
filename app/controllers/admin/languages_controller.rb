class Admin::LanguagesController < ApplicationController
  # GET /admin/languages
  # GET /admin/languages.xml
  layout 'scaffold'
  def index
    @languages = Language.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @languages }
    end
  end

  # GET /admin/languages/1
  # GET /admin/languages/1.xml
  def show
    @language = Language.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @language }
    end
  end

  # GET /admin/languages/new
  # GET /admin/languages/new.xml
  def new
    @language = Language.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @language }
    end
  end

  # GET /admin/languages/1/edit
  def edit
    @language = Language.find(params[:id])
  end

  # POST /admin/languages
  # POST /admin/languages.xml
  def create
    @language = Language.new(params[:language])

    respond_to do |format|
      if @language.save
        format.html { redirect_to(admin_languages_path, :notice => 'Language was successfully created.') }
        format.xml  { render :xml => @language, :status => :created, :location => @language }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/languages/1
  # PUT /admin/languages/1.xml
  def update
    @language = Language.find(params[:id])

    respond_to do |format|
      if @language.update_attributes(params[:admin_language])
        format.html { redirect_to(admin_languages_path, :notice => 'Language was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/languages/1
  # DELETE /admin/languages/1.xml
  def destroy
    @language = Language.find(params[:id])
    @language.destroy

    respond_to do |format|
      format.html { redirect_to(admin_languages_path) }
      format.xml  { head :ok }
    end
  end
end
