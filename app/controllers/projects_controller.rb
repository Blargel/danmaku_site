class ProjectsController < ApplicationController
  inherit_resources
  include PermalinkResources
  belongs_to :user, :finder => :find_by_permalink!, :optional => true

  # preload all resource / collection in before filter
  before_action :collection, :only =>[:index]
  before_action :resource, :only => [:show, :edit, :update, :destroy]
  before_action :build_resource, :only => [:new, :create, :index]

  authorize_resource

  # Change redirect
  destroy! do |success, failure|
    success.html {redirect_to user_path(@user)}
    failure.html {redirect_to user_project_path(@user, @project)}
  end

  private

  def permitted_params
    params.permit(project: [
      :title, :danmakufu_version_id, :version_number,
      :category_id, :description, :tag_list, :unlisted,
      :youtube_video_id, { images_attributes: [:attachment] }
    ])
  end

  # Filter, order, and paginate the collection
  def _collection
    @search = end_of_association_chain.joins(:archive).where("unlisted = false AND attachable_id IS NOT NULL")
    @search = @search.where(:soft_deleted => false)

    if current_user && current_user.admin? && params[:search]
      unlisted = params[:search]["unlisted"].blank? ? false : params[:search]["unlisted"]
    else
      unlisted = false
    end
    @search = @search.where(:unlisted => unlisted)

    filter_collection
    order_collection

    @search.page(params[:page])
  end

  # Applies filtering based off the search param.
  def filter_collection
    if params[:search]
      title_like = params[:search]["title_like"].blank? ? nil : params[:search]["title_like"]
      user_login_like = params[:search]["user_login_like"].blank? ? nil : params[:search]["user_login_like"]
      tagged_with = params[:search]["tagged_with"].blank? ? nil : params[:search]["tagged_with"]
      category_is = params[:search]["category_is"].blank? ? nil : params[:search]["category_is"]
      danmakufu_version_is = params[:search]["danmakufu_version_is"].blank? ? nil : params[:search]["danmakufu_version_is"]

      @search = @search.where("UPPER(title) LIKE UPPER( ? )", "%#{title_like}%")                           if title_like
      @search = @search.joins(:user).where("UPPER(users.login) LIKE UPPER( ? )", "%#{user_login_like}%")   if user_login_like
      @search = @search.tagged_with(tagged_with)                                                           if tagged_with
      @search = @search.joins(:category).where("categories.id = ?", category_is)                           if category_is
      @search = @search.joins(:danmakufu_version).where("danmakufu_versions.id = ?", danmakufu_version_is) if danmakufu_version_is
    end
  end

  # Applies ordering based off the search order param. Defaults to "descend_by_created_at"
  def order_collection
    order = params[:search] && params[:search][:order]
    order ||= "descend_by_updated_at"

    order_arr = order.split("_by_")
    direction = order_arr[0]
    column = order_arr[1]

    if direction == "ascend"
      direction = "ASC"
    else
      direction = "DESC"
    end

    if ["created_at", "updated_at", "title", "downloads"].include? column
      @search = @search.order("#{column} #{direction}")
    end
  end
end
