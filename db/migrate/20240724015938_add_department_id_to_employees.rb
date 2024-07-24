class AddDepartmentIdToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :department_id, :integer, null: false
  end
end
