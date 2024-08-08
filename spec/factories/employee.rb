FactoryBot.define do

  factory :first_employee, class: Employee do
    name { "テスト" }
    name_kana { 'てすと' }
    employee_number { 'N11111' }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    association :department
  end

  factory :second_employee, class: Employee  do
    name { "テスト2" }
    name_kana { 'てすとつー' }
    employee_number { 'N22222' }
    email { "test2@example.com" }
    password { "password" }
    password_confirmation { "password" }
    association :department
  end

  factory :super_admin, class: Employee do
    name { "スーパーアドミン" }
    name_kana { 'すーぱーあどみん' }
    employee_number { 'N33333' }
    email { "superadmin@example.com" }
    password { "password" }
    password_confirmation { "password" }
    association :department

    after(:create) do |employee|
      role = Role.create(name: 'super_admin')
      employee.update_role(role.id)
    end

  end

  factory :admin, class: Employee do
    name { "アドミン" }
    name_kana { 'あどみん' }
    employee_number { 'N44444' }
    email { "admin@example.com" }
    password { "password" }
    password_confirmation { "password" }
    association :department

    after(:create) do |employee|
      role = Role.create(name: 'admin')
      employee.update_role(role.id)
    end
  end

  factory :dept_admin, class: Employee do
    name { "部署アドミン" }
    name_kana { 'ぶしょあどみん' }
    employee_number { 'N55555' }
    email { "department@example.com" }
    password { "password" }
    password_confirmation { "password" }
    association :department

    after(:create) do |employee|
      role = Role.create(name: 'department_admin')
      employee.update_role(role.id)
    end
  end

end
