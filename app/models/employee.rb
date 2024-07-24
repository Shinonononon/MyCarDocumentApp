class Employee < ApplicationRecord
  has_one :driver_license
  has_one :vehicle_inspection
  has_one :compulsory_insurance
  has_one :optional_insurance
  belongs_to :department
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
