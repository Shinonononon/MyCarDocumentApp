FactoryBot.define do
  factory :vehicle_inspection do
    expiration_date { Date.today + 1.month }
    employee
  end
end
