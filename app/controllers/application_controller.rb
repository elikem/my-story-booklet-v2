class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  layout :layout_by_resource

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :first_name, :last_name, :country_of_residence, :username) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :first_name, :last_name, :country_of_residence, :username) }
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  add_flash_types :success, :error, :warning
end
