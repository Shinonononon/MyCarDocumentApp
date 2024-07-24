class Ability
  include CanCan::Ability

  def initialize(employee)
    employee ||= Employee.new # guest user (not logged in)

    if employee.has_role?(:super_admin)
      can :manage, :all
      cannot :update, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection]
    elsif employee.has_role?(:admin)
      can :manage, Employee
      can :manage, Department
      can :read, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], employee_id: employee.id
      cannot :read, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], :photo
      cannot :update, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection]
    elsif employee.has_role?(:department_admin)
      can :manage, Employee, department: employee.department
      can :read, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], employee: { department: employee.department }
      cannot :read, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], :photo
      cannot :update, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection]
    else
      can :read, Employee, id: employee.id
      can :update, Employee, id: employee.id, only: [:email, :password, :password_confirmation]
      can :read, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], employee_id: employee.id
      can :update, [CompulsoryInsurance, DriverLicense, OptionalInsurance, VehicleInspection], employee_id: employee.id
    end
  end
end
