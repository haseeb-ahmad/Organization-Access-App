class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_organization
  before_action :authenticate_user!

  helper_method :current_organization

  def require_organization!
    unless current_organization
      redirect_to organizations_path, alert: "Please select an organization first."
    end
  end

  def after_invite_path_for(resource)
    if defined?(current_organization) && current_organization.present?
      organization_memberships_path(current_organization)
    else
      authenticated_root_path # fallback
    end
  end
  
 
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end

  def set_current_organization
    if session[:current_organization_id].present? && current_user
      @current_organization ||= policy_scope(Organization).find_by(id: session[:current_organization_id])
    end
  end

  def current_organization
    @current_organization
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:dob, :custom_attributes])
    end
end
