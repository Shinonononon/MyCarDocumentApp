class EmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    if current_employee.has_role?(:super_admin) || current_employee.has_role?(:admin)
      @employees = Employee.all.includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance)
    elsif current_employee.has_role?(:department_admin)
      @employees = Employee.where(department_id: current_employee.department_id).includes(:department, :driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance)
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def show
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: 'Employee was successfully created.'
    else
      render :new
    end
  end

  def edit
    if current_employee.has_role?(:super_admin)
      render 'super_admin/employees/edit'
    elsif current_employee.has_role?(:admin)
      render 'admin/employees/edit'
    elsif current_employee.has_role?(:department_admin)
      render 'department_admin/employees/edit'
    else
      render 'employees/edit'
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: 'Employee was successfully updated.'
    else
      if current_employee.has_role?(:super_admin)
        render 'super_admin/employees/edit'
      elsif current_employee.has_role?(:admin)
        render 'admin/employees/edit'
      elsif current_employee.has_role?(:department_admin)
        render 'department_admin/employees/edit'
      else
        render 'employees/edit'
      end
    end
  end

  def destroy
    if current_employee.has_role?(:super_admin) || current_employee.has_role?(:admin) || current_employee.has_role?(:department_admin)
      @employee.destroy
      redirect_to employees_url, notice: 'Employee was successfully destroyed.'
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    if current_employee.has_role?(:super_admin) || current_employee.has_role?(:admin) || current_employee.has_role?(:department_admin)
      params.require(:employee).permit(:name, :employee_number, :department_id, :email, :password, :password_confirmation)
    else
      params.require(:employee).permit(:email, :password, :password_confirmation)
    end
  end
end
