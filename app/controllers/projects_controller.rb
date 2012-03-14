class ProjectsController < ApplicationController
  inherit_resources
  include PermalinkResources
  belongs_to :user, :finder => :find_by_permalink!, :optional => true  

  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  
  authorize_resource
  
  
  # Change redirect
  destroy! do |success, failure|
    success.html {redirect_to user_path(@user)}
  end

  def show
    version = @project.versions.last
    redirect_to user_project_version_path(@user, @project, version)
  end


  private
  # Paginate the projects collection  
  def _collection
    @search = end_of_association_chain
    if params[:search]
      title_like = params[:search]["title_like"].blank? ? nil : params[:search]["title_like"]
      user_login_like = params[:search]["user_login_like"].blank? ? nil : params[:search]["user_login_like"]
      tagged_with = params[:search]["tagged_with"].blank? ? nil : params[:search]["tagged_with"]
    
      if title_like
        @search = @search.where("UPPER(title) LIKE UPPER( ? )", "%#{title_like}%")
      end
    
      if user_login_like
        @search = @search.joins(:user).where("UPPER(users.login) LIKE UPPER( ? )", "%#{user_login_like}%")
      end
    
      if tagged_with
        @search = @search.tagged_with(tagged_with)
      end
      
      if !params[:search][:order].blank?
        order = params[:search][:order].split("_by_")
        direction = order[0]
        column = order[1]
        
        if direction == "ascend"
          direction = "ASC"
        else
          direction = "DESC"
        end
        
        if ["created_at", "title", "win_votes", "downloads"].include? column
          @search = @search.order("#{column} #{direction}")
        end
      end
    else
      @search = @search.all
    end
    
    @search.paginate( :per_page => 10, :page => params[:page] )
  end
end
