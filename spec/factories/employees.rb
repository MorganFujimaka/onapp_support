FactoryGirl.define do
  factory :employee do
    association :department, factory: :department
    association :user, factory: :user
  end
end
