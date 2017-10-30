require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, alert: "Could not find what you were looking for. Please check that you have a correct URL address."
  end
  
  rescue_from ActiveRecord::StaleObjectError do
    flash[:alert] = "Another user has made a change to that record since you accessed the edit form."
    if request.format == :js
      render_exception
    else
      redirect_to root_url
    end
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone])
  end
  
  def render_exception
    render template: "common/exception.js"
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  def xeditable?(object = nil)
    can?(:update, object)
  end
  helper_method :xeditable?
end
