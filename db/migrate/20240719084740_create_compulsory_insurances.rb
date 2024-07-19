class CreateCompulsoryInsurances < ActiveRecord::Migration[6.1]
  def change
    create_table :compulsory_insurances do |t|
      t.date :expiration_date, null:false

      t.timestamps
    end
  end
end
