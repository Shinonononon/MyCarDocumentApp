class DepartmentsController < ApplicationController
  before_action :authenticate_employee!
  before_action :authorize_admin!

  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: 'Department was successfully created.'
    else
      render :new
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_employee.has_role?(:admin) || current_employee.has_role?(:super_admin)
  end

  def department_params
    params.require(:department).permit(:name)
  end
end
