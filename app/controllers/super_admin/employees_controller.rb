module SuperAdmin
  class EmployeesController < ApplicationController
    before_action :super_admin_required
    before_action :authenticate_employee!
    before_action :set_employee, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource

    def index
      @search_params = employee_search_params
      @employees = Employee.all.includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance).search(@search_params)
    end

    def show
      @employee = Employee.find(params[:id])
    end

    def new
      @employee = Employee.new
    end

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        redirect_to super_admin_employees_path, notice: 'Employee was successfully created.'
      else
        render :new
      end
    end

    def edit
      render 'super_admin/employees/edit'
    end

    def update
      if @employee.update(employee_params)
        @employee.update_role(params[:employee][:roles])
        redirect_to super_admin_employees_path, notice: 'Employee was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @employee.destroy
      redirect_to super_admin_employees_path, notice: 'Employee was successfully destroyed.'
    end

    private

    def employee_search_params
      params.fetch(:search, {}).permit(:name, :employee_number, :department)
    end

    def super_admin_required
      unless current_employee&.has_role?(:super_admin)
        flash[:notice] = t('common.admin_required')
        redirect_to pages_index_path
      end
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:name,:name_kana,:employee_number, :department_id, :email, :password, :password_confirmation, :role_ids)
    end
  end
end
