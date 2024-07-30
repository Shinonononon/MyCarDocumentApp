class EmployeesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_employee!
  before_action :set_employee, only: [:show, :edit, :update]

  def edit

  end

  def update

    if @employee.update(employee_params)
      sign_in :employee, @employee, bypass: true
      redirect_to uploads_documents_path, notice: 'Employee was successfully updated.'
    else
      render :edit
    end
  end



  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    if current_employee.has_role?(:super_admin) || current_employee.has_role?(:admin) || current_employee.has_role?(:department_admin)
      params.require(:employee).permit(:name,:name_kana,:employee_number, :department_id, :email, :password, :password_confirmation, :role_ids)
    else
      params.require(:employee).permit(:email, :password, :password_confirmation)
    end
  end
end
