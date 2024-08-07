FactoryBot.define do
  factory :compulsory_insurance do
    expiration_date { Date.today + 2.month }
    association :employee
  end
end
