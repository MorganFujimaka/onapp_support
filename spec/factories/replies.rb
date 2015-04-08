FactoryGirl.define do
  factory :reply do
    body { Faker::Lorem.paragraph }
    association :employee, factory: :employee
    association :ticket, factory: :ticket
  end
end
