# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |i|
  Department.create!(
    name: "部署#{i + 1}"
  )
end

10.times do |i|
  Employee.create!(
  name: "テスト #{i + 1}",
  name_kana: "てすと",
  email: "test#{i + 1}@example.com",
  employee_number: "TTT1234#{i + 1}",
  department_id: 1 ,
  password: 'password',
  password_confirmation: 'password',
  )
end
