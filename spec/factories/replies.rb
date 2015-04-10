FactoryGirl.define do
  factory :reply do
    body { Faker::Lorem.paragraph }
    employee
    ticket
  end
end
