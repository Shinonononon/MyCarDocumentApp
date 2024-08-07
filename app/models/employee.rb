class Employee < ApplicationRecord
  has_one :driver_license, dependent: :destroy
  has_one :vehicle_inspection, dependent: :destroy
  has_one :compulsory_insurance, dependent: :destroy
  has_one :optional_insurance, dependent: :destroy

  belongs_to :department
  rolify
  after_create :assign_default_role
  before_destroy :dont_delete_last_super_admin, prepend: true
  # before_update :dont_edit_last_super_admin, prepend: true


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true
  validates :name_kana, presence: true, format: { with: /\A[ぁ-んー－]+\z/, message: 'はひらがなのみ入力可能です。' }
  validates :employee_number, presence: true, uniqueness: true
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

  # メーラー
  def self.send_expiration_notifications
    Employee.includes(:driver_license, :vehicle_inspection, :compulsory_insurance, :optional_insurance).find_each do |employee|
      documents = []
      documents << employee.driver_license if employee.driver_license&.expiration_date == Date.today + 1.month
      documents << employee.vehicle_inspection if employee.vehicle_inspection&.expiration_date == Date.today + 1.month
      documents << employee.compulsory_insurance if employee.compulsory_insurance&.expiration_date == Date.today + 1.month
      documents << employee.optional_insurance if employee.optional_insurance&.expiration_date == Date.today + 1.month

      if documents.any?
        DocumentMailer.expiration_notification(employee, documents).deliver_now
      end
    end
  end

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

  # アドミン消させないやつ

  def dont_delete_last_super_admin
    if has_role?(:super_admin) && Employee.with_role(:super_admin).count <= 1
      errors.add(:base, "スーパー管理者が一人になるため、ロールの削除ができませんでした。")
      throw(:abort)
    end
  end

  # 対象のroleがsuperadminじゃない時は無条件でupdateできる
  # superadmin数が2人以上だったらupdateできる
  def can_edit_last_super_admin(role_id)
    if roles.first.name != "super_admin" ||
      Employee.with_role(:super_admin).count > 1 ||
      (Employee.with_role(:super_admin).count <= 1 &&
      roles.first.id == role_id)
      return true
    end
    errors.add(:base, 'スーパー管理者が一人になるため、ロールの編集ができません。')
    return false
  end



  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email = conditions.delete(:email)
    where(conditions.to_h).where(["lower(email) = :value", { value: email.downcase }]).first
  end
end
