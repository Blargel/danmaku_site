class ApplicationController < ActionController::Base
  include Authentication
  include InheritedResources::DSL

  before_action :block_ip_addresses

  helper :all
  helper_method :current_user_session, :current_user, :set_current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  protected

  def block_ip_addresses
    head :unauthorized if BlockedIp.include?(current_ip_address)
  end

  def current_ip_address
    request.headers["CF-Connecting-IP"] || request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
  end
end
