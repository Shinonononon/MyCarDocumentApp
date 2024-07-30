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

  # search
  scope :search, ->(search_params) {
    return if search_params.blank?

    search_name(search_params[:name])
      .search_number(search_params[:employee_number])
      .search_department(search_params[:department])
  }

  scope :search_name, ->(name) { where('name LIKE ?', "%#{name}%") if name.present? }
  scope :search_number, ->(employee_number) { where('employee_number LIKE ?', "%#{employee_number}%") if employee_number.present? }
  scope :search_department, ->(department) { joins(:department).where(department: { id: department }) if department.present? }

  # default role
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
