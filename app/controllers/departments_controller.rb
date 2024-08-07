class DepartmentsController < ApplicationController
  before_action :authenticate_employee!
  before_action :authorize_admins!
  before_action :set_department, only: %i[edit update destroy]


  def index
    @departments = Department.all
  end

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to departments_path, notice: '部署が作成されました'
    else
      render :new
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    if @department.update(department_params)
      redirect_to departments_path, notice: '部署が編集されました'
    else
      render :edit
    end
  end

  def destroy
    @department.destroy
    redirect_to departments_path, notice: '部署が削除されました'
  end

  private

  def authorize_admins!
    unless  current_employee.has_role?(:admin) || current_employee.has_role?(:super_admin)
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def set_department
    @department = Department.find(params[:id])
  end

  def department_params
    params.require(:department).permit(:name)
  end
end
