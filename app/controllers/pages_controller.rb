class PagesController < ApplicationController
  before_action :authenticate_employee!


  def index
    @driver_license = current_employee.driver_license
    if current_employee.has_role?(:super_admin)
      render 'pages/super_admin_view'
    elsif current_employee.has_role?(:admin)
      render 'pages/admin_view'
    elsif current_employee.has_role?(:department_admin)
      render 'pages/department_admin_view'
    else
      render 'pages/general_view'
    end

  end


  def help
    @driver_license = current_employee.driver_license
  end

  private

end
