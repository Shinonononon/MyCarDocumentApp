module DepartmentAdmin
  class EmployeesController < ApplicationController
    before_action :department_admin_required
    before_action :authenticate_employee!
    before_action :set_employee, only: [:show]
    load_and_authorize_resource

    def index
      @employees = Employee.where(department: current_employee.department).includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance)
    end

    def show
      @employee = Employee.find(params[:id])
    end


    private

    def department_admin_required
      unless current_employee&.has_role?(:department_admin)
        flash[:notice] = t('common.admin_required')
        redirect_to pages_index_path
      end
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

  end
end
