FactoryBot.define do
  factory :department_first, class: Department do
    name { "TestDepartment1" }
  end

  factory :department_second, class: Department do
    name { "TestDepartment2" }
  end
end
