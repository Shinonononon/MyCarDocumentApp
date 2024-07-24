class CreateVehicleInspections < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicle_inspections do |t|
      t.date :expiration_date, null:false
      t.integer :employee_id, null: false

      t.timestamps
    end
  end
end
