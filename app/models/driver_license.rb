class DriverLicense < ApplicationRecord
  belongs_to :employee

  validate :date_not_in_past

  # その他の設定
  has_one_attached :photo
  validates :expiration_date, presence: true
  # validates :photo, presence: true

  scope :expiring_soon, -> { where(expiration_date: Date.today + 1.month) }

end
