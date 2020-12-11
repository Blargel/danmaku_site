module Authorization
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this page"
      redirect_to request.request_uri || root_path
      return false
    end
  end
  
  def user_to_match
    if params[:action] == "index"
      collection
    elsif params[:action] == "new" || params[:action] == "create"
      build_resource
    else
      resource
    end
    @user
  end
  
  def ownable
    if params[:action] == "index" || params[:action] == "new" || params[:action] == "create"
      return parent
    else
      return resource
    end
  end
  
  def access_denied_path
    root_path
  end
  
  def access_denied!
    flash[:error] = "You do not have the permissions to do that action."  
    redirect_to access_denied_path
    false
  end
  
  # Require current user to be the @user found from params
  def require_matching_user
    access_denied! if !current_user || !user_to_match || current_user != user_to_match
  end
  
  # Require the current user to be the owner of the project
  def require_owner
    access_denied! if !current_user || !ownable || !current_user.owner_of?(ownable)
  end

end