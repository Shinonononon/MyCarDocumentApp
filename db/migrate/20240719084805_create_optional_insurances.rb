class CreateOptionalInsurances < ActiveRecord::Migration[6.1]
  def change
    create_table :optional_insurances do |t|
      t.date :expiration_date, null:false

      t.timestamps
    end
  end
end
