class Employee < ApplicationRecord
  has_one :driver_license, dependent: :destroy
  has_one :vehicle_inspection, dependent: :destroy
  has_one :compulsory_insurance, dependent: :destroy
  has_one :optional_insurance, dependent: :destroy

  belongs_to :department
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :employee_number, presence: true
  validates :department_id, presence: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    employee_number = conditions.delete(:employee_number)
    where(conditions).where(["employee_number = :value", { value: employee_number }]).first
  end
end
