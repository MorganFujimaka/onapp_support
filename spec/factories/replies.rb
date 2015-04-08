FactoryGirl.define do
  factory :reply do
    body Faker::Lorem.paragraph
    association :user, factory: :user
    association :ticket, factory: :ticket
  end
end
