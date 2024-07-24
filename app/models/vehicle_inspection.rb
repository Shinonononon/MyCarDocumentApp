class VehicleInspection < ApplicationRecord
  belongs_to :employee

  # その他の設定
  has_one_attached :photo
  validates :expiration_date, presence: true
end
