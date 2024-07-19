class CreateDriverLicenses < ActiveRecord::Migration[6.1]
  def change
    create_table :driver_licenses do |t|
      t.date :expiration_date, null:false

      t.timestamps
    end
  end
end
