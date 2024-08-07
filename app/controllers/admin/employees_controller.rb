module Admin
  class EmployeesController < ApplicationController
    before_action :admin_required
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
        redirect_to admin_employees_path, notice: 'アカウントが作成されました'
      else
        render :new
      end
    end

    def edit
      if @employee.has_role?(:super_admin) && !current_employee.has_role?(:super_admin)
        redirect_to admin_employees_path, notice: '編集権限がありません'
      else
        render 'admin/employees/edit'
      end
    end

    def update
      if @employee.update(employee_params)
        redirect_to admin_employees_path, notice: 'アカウントが更新されました'
      else
        render :edit
      end
    end

    def destroy
      if @employee.has_role?(:super_admin) && !current_employee.has_role?(:super_admin)
        redirect_to admin_employees_path, notice: 'スーパー管理者の削除権限がありません'
      elsif @employee.destroy
        redirect_to admin_employees_path, notice: 'アカウントが削除されました'
      else
        redirect_to admin_employees_path, alert: @employee.errors.full_messages.to_sentence
      end
    end

    private

    def employee_search_params
      params.fetch(:search, {}).permit(:name, :employee_number, :department)
    end

    def admin_required
      unless current_employee&.has_role?(:admin)
        flash[:alert] = 'アクセス権限がありません'
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
