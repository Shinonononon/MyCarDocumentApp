class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_employee)
  end

  rescue_from StandardError, with: :render500
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render500(error = nil)
    Rails.logger.error("❌#{error.message}") if error
    render template: 'errors/error500.html', layout: 'error', status: :internal_server_error
  end
  def render404(error = nil)
    Rails.logger.error("❌#{error.message}") if error
    render template: 'errors/error404.html', layout: 'error', status: :not_found
  end

  def employee_search_params
    params.fetch(:search, {}).permit(:name, :employee_number, :department)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end
end
