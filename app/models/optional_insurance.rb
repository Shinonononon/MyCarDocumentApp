class OptionalInsurance < ApplicationRecord
  belongs_to :employee

  # その他の設定
  has_one_attached :photo
  validates :expiration_date, presence: true
  # validates :photo, presence: true

  scope :expiring_soon, -> { where(expiration_date: Date.today + 1.month) }

  attr_accessor :skip_submission
end
