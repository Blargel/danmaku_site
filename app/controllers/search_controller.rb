class SearchController < ApplicationController
  def search
    @search = Project
    filter_collection
    order_collection
    @search.paginate( :per_page => 10, :page => params[:page] )
  end

  private

  # Applies filtering based off the search param.
  def filter_collection
    if params[:search]
      if current_user && current_user.admin?
        case params[:search]["unlisted"]
        when "true"
          @unlisted = true
        when "false"
          @unlisted = false
        else
          @unlisted = nil
        end
      else
        @unlisted = false
      end
      @title_like = params[:search]["title_like"].blank? ? nil : params[:search]["title_like"]
      @user_login_like = params[:search]["user_login_like"].blank? ? nil : params[:search]["user_login_like"]
      @tagged_with = params[:search]["tagged_with"].blank? ? nil : params[:search]["tagged_with"]
      @category_is = params[:search]["category_is"].blank? ? nil : params[:search]["category_is"]
      @danmakufu_version_is = params[:search]["danmakufu_version_is"].blank? ? nil : params[:search]["danmakufu_version_is"]


      @search = @search.where(:unlisted => @unlisted)                                                       unless @unlisted.nil?
      @search = @search.where("UPPER(title) LIKE UPPER( ? )", "%#{@title_like}%")                           unless @title_like.nil?
      @search = @search.joins(:user).where("UPPER(users.login) LIKE UPPER( ? )", "%#{@user_login_like}%")   unless @user_login_like.nil?
      @search = @search.tagged_with(@tagged_with)                                                           unless @tagged_with.nil?
      @search = @search.joins(:category).where("categories.id = ?", @category_is)                           unless @category_is.nil?
      @search = @search.joins(:danmakufu_version).where("danmakufu_versions.id = ?", @danmakufu_version_is) unless @danmakufu_version_is.nil?
    end
  end

  # Applies ordering based off the search order param. Defaults to "descend_by_created_at"
  def order_collection
    order = params[:search] && params[:search][:order]
    order ||= "descend_by_updated_at"

    direction, column = order.split("_by_")

    if direction == "ascend"
      direction = "ASC"
    else
      direction = "DESC"
    end

    if ["created_at", "updated_at", "title", "win_votes", "downloads"].include? column
      @search = @search.order("#{column} #{direction}")
    end
  end
end
