FactoryBot.define do
  factory :optional_insurance do
    expiration_date { Date.today + 2.month }
    association :employee
  end
end
