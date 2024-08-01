FactoryBot.define do
  factory :driver_license do
    expiration_date { Date.today + 1.month }
    employee
  end
end
