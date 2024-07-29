module Admin
  class EmployeesController < ApplicationController
    before_action :admin_required
    before_action :authenticate_employee!
    before_action :set_employee, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource

    def index
      @employees = Employee.all.includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance)
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
        redirect_to admin_employees_path, notice: 'Employee was successfully created.'
      else
        render :new
      end
    end

    def edit
      render 'admin/employees/edit'
    end

    def update
      if @employee.update(employee_params)
        @employee.update_role(params[:employee])
        redirect_to admin_employees_path, notice: 'Employee was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @employee.destroy
      redirect_to admin_employees_path, notice: 'Employee was successfully destroyed.'
    end

    private

    def admin_required
      unless current_employee&.has_role?(:admin)
        flash[:notice] = t('common.admin_required')
        redirect_to pages_index_path
      end
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:name, :employee_number, :department_id, :email, :password, :password_confirmation, :role_ids)
    end
  end
end
