FactoryBot.define do
  factory :vehicle_inspection do
    expiration_date { Date.today + 1.month }
    association :employee
  end
end
