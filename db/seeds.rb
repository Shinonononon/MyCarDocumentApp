# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Department.create!([
{name: '人事部'},
{name: '営業部'},
{name: '総務部'}
])

department1 = Department.find_by(name: '人事部')
department2 = Department.find_by(name: '営業部')
department3 = Department.find_by(name: '総務部')

super_admin = Role.create!(name: 'super_admin')
admin = Role.create!(name: 'admin')
dept_admin = Role.create!(name: 'department_admin')

super_emp = Employee.create!(
  name: "スーパーアドミン",
  name_kana: "すーぱーあどみん",
  email: "super_admin@example.com",
  employee_number: "SSS12345",
  department_id: department1.id ,
  password: 'password',
  password_confirmation: 'password',
)

admin_emp = Employee.create!(
name: "アドミン",
name_kana: "あどみん",
email: "admin@example.com",
employee_number: "AAA12345",
department_id: department1.id ,
password: 'password',
password_confirmation: 'password',
)

dept_emp1 = Employee.create!(
name: "部署アドミン1",
name_kana: "ぶしょあどみんいち",
email: "dept_admin1@example.com",
employee_number: "DDD11111",
department_id: department2.id ,
password: 'password',
password_confirmation: 'password',
)

dept_emp2 = Employee.create!(
name: "部署アドミン2",
name_kana: "ぶしょあどみんに",
email: "dept_admin2@example.com",
employee_number: "DDD22222",
department_id: department3.id ,
password: 'password',
password_confirmation: 'password',
)

super_emp.update_role(super_admin.id)
admin_emp.update_role(admin.id)
dept_emp1.update_role(dept_admin.id)
dept_emp2.update_role(dept_admin.id)


5.times do |i|
  Employee.create!(
  name: "営業部テスト #{i + 1}",
  name_kana: "えいぎょうぶてすと",
  email: "seles_test#{i + 1}@example.com",
  employee_number: "TTT1234#{i + 1}",
  department_id: department2.id ,
  password: 'password',
  password_confirmation: 'password',
  )
end

5.times do |i|
  Employee.create!(
  name: "総務部テスト #{i + 1}",
  name_kana: "そうむぶてすと",
  email: "soumu_test#{i + 1}@example.com",
  employee_number: "TTT5432#{i + 1}",
  department_id: department3.id ,
  password: 'password',
  password_confirmation: 'password',
  )
end
