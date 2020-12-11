class ArchivesController < ApplicationController
  inherit_resources
  acts_as_singleton!
  actions :create, :show, :destroy
  belongs_to :user, :finder => :find_by_permalink! do
    belongs_to :project, :finder => :find_by_permalink!
  end

  # preload all resource / collection in before filter
  before_action :collection, :only =>[:index]
  before_action :resource, :only => [:show, :edit, :update, :destroy]
  before_action :build_resource, :only => [:new, :create, :index]


  def show
    show! do |format|
      @project.increment_download_counter!
      format.html { redirect_to @project.archive.attachment_url }
    end
  end

  def create
    @archive.import_s3_data
    @archive.attachable = @project

    create! do |success, failure|
      success.json {
        str = render_to_string :template => 'projects/_archive.html.erb', :locals => { :user => @user, :project => @project }, :layout => false
        render :json => {
          :success => true,
          :replace_dom => '#archive',
          :partial => str
        }.to_json
      }
      failure.json { render :json => { :success => false, :errors => @archive.errors }.to_json }
    end
  end

  def destroy
    destroy! do |format|
      format.html {redirect_to user_project_path(@user, @project)}
    end
  end

  private

  def permitted_params
    params.permit(archive: [])
  end
end
