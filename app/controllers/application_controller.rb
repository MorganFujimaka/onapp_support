class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path, alert: controller_name.singularize.capitalize << " cannot be found"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end
end
