FactoryBot.define do
  factory :employee do
    name { "Test Employee" }
    name_kana { 'てすと'}
    employee_number {'N11111'}
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    department
  end
end
