class Employee < ApplicationRecord
  has_one :driver_license, dependent: :destroy
  has_one :vehicle_inspection, dependent: :destroy
  has_one :compulsory_insurance, dependent: :destroy
  has_one :optional_insurance, dependent: :destroy

  belongs_to :department
  rolify
  after_create :assign_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :employee_number, presence: true
  validates :department_id, presence: true

  def assign_default_role
    self.add_role(:general) if self.roles.blank?
  end

  def update_role(role_id)
    # すでにrole持ってたら引数で受け取ったrole_nameにupdateする
    role = Role.find(role_id)
    role_name = role.name
    if self.roles.present?
      self.remove_role(self.roles.first.name)
    end
    self.add_role(role_name)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["lower(email) = :value", { value: email.downcase }]).first
  end
end
