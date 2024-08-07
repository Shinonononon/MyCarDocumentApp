module DepartmentAdmin
  class EmployeesController < ApplicationController
    before_action :department_admin_required
    before_action :authenticate_employee!
    before_action :set_employee, only: [:show]
    load_and_authorize_resource

    def index
      @search_params = employee_search_params
      @employees = Employee.where(department: current_employee.department).includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance).search(@search_params)
    end

    def show
      @employee = Employee.find(params[:id])
    end


    private

    def employee_search_params
      params.fetch(:search, {}).permit(:name, :employee_number)
    end

    def department_admin_required
      unless current_employee&.has_role?(:department_admin)
        flash[:alert] = 'アクセス権限がありません'
        redirect_to pages_index_path
      end
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

  end
end
