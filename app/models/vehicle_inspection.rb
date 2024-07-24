class VehicleInspection < ApplicationRecord
  belongs_to :employee
  has_one_attached :photo
end
